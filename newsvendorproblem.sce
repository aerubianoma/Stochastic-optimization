  // demand 
  wsharp=100;// no larger, else the Poisson distribution cannot be computed
  wflat=1;
  demand=[wflat:wsharp];
  
  // control
  control=[demand,1+demand($)];
  
  // Criterion / costs 
  cc=1;pp=10*cc;
  // cc=1 ; pp=1.1*cc ; 
  // avoid that cc/pp is the inverse of an integer 
  // when the distribution of demand is uniform
  costs=cc*control'*ones(demand)-pp*min(ones(control')*demand,control'*ones(demand));
  // one row by control, one column by demand
  probab=ones(demand);
  probab=probab/sum(probab);
  //exec('newsvendor_data.sce');exec('newsvendor_uniform.sce');exec('newsvendor_main.sce')
  
  xset("window",1);clf();plot2d2(demand,probab)
  xtitle("Histogram of the demand")
  
  // Criterion / expected costs
  criterion=probab*costs';
  // a row vector
  xset("window",3);clf();plot2d2(control,criterion)
  xtitle("The expected costs as function of the decision")
  
  // Optimal decision 
  [lhs,optcont]=min(criterion);
  disp("The optimal decision is "+string(optcont))
  
  // Naive deterministic solution
  meandemand=probab*demand';
  disp("The expected demand is "+string(round(meandemand)))
  
  // Check that the optimal decision satisfies the optimality condition 
  cumprobab=cumsum(probab);
  decumprobab=1-cumprobab;
  
  xset("window",4);clf();plot2d2(demand,decumprobab,rect = [demand(1)-1,0,demand($),1]);
  plot2d(demand,cc/pp*ones(decumprobab),style = 5);
  xtitle("The decumulative distribution of the demand")
  
  disp("Is it true that "+string(cc/pp)+" lies between "+string(decumprobab(optcont))+ ...
       " and "+string(decumprobab(optcont-1))+"?")
  
  NS=365;
  // simulated demands 
  DD=grand(NS,'markov',ones(probab')*probab,1);
  
  time=[1:NS];
  
  xset("window",8);clf();
  plot2d2(time,cumsum(-costs(round(meandemand),DD)),style = 3);
  plot2d2(time,cumsum(-costs(optcont,DD)),style = 5);
  legends(["optimal solution "+string(optcont);
           "naive deterministic solution "+string(round(meandemand))],[5,3],"lr");
  xtitle("The cumulated payoffs as function of the number of days","time","payoff")
  
  
  xset("window",10);clf();
  uu=optcont;
  ss=5;
  plot2d2([costs(uu,[wflat:(uu-1)]),costs(uu,uu)], ...
          [probab([wflat:(uu-1)]),decumprobab(uu-1)],style = ss, ...
          rect = [min(costs),0,max(costs),1]);
  //
  uu=round(meandemand);
  ss=3;
  plot2d2([costs(uu,[wflat:(uu-1)]),costs(uu,uu)], ...
          [probab([wflat:(uu-1)]),decumprobab(uu-1)],style = ss, ...
          rect = [min(costs),0,max(costs),1]);
  //
  legends(["optimal solution "+string(optcont);
           "naive deterministic solution "+string(round(meandemand))],[5,3],"ur");
  xtitle("Histograms of the costs")