%SA for single machine problem with weighted tardiness objective
clear all;
clc;
p = [12 8 15 9];
w = [4 5 3 5];
d = [16 26 25 27];
T = 1000;
n=size(p,2);

curr_schedule = [ ];
neighbor_schedule = [ ];

curr_schedule = randperm(n);
best_schedule = curr_schedule;

curr_sol = weighted_tardiness(p,w,d,n,curr_schedule);
best_sol = curr_sol;
iteration = 1;
alpha = 0.9;
AllSolution = [ ];

while (T>1)
    
    %neighborhood - choose a job and swap it with the next job; if the
    %chosen job is the last job then swap it with the preceding job
    source = randi(n);
    Index = find(curr_schedule==source);
    
    if (Index < n)
        neighbor_schedule = [curr_schedule(1:Index-1) curr_schedule(Index+1) curr_schedule(Index) curr_schedule(Index+2:n)];
    else
        neighbor_schedule = [curr_schedule(1:Index-2) curr_schedule(Index) curr_schedule(Index-1)];
    end
    
    neighbor_sol = weighted_tardiness(p,w,d,n,neighbor_schedule);
    
    %if the neighboring solution is better than the best, then update the
    %best and the current solution and schedule
    if neighbor_sol < best_sol
        best_sol = neighbor_sol;
        best_schedule = neighbor_schedule;
        current_schedule = neighbor_schedule;
        current_sol = neighbor_sol;
    end
    
    %if the neighboring schedule is worse compared to the current solution,
    %accept the neighboring schedule based on the probability
    if neighbor_sol > curr_sol;
        U =rand;
        if U < exp((curr_sol-neighbor_sol)/T)
            curr_sol = neighbor_sol;
            curr_schedule = neighbor_schedule;
        end
    end
    
    AllSolution = [AllSolution; T, best_sol, curr_sol];
    
    T = alpha^iteration *T;
end
set(gca,'XDir','reverse');
plot(AllSolution(:,1),AllSolution(:,2),AllSolution(:,1), AllSolution(:,3));

best_schedule
best_sol