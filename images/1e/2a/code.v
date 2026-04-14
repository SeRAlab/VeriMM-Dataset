module AStarCalculator (
    input [7:0] g,          // current cost
    input [7:0] h,          // heuristic cost
    input goal_reached,     // flag indicating if the goal has been reached
    output reg [7:0] f      // total estimated cost
);
    always @(*) begin
        if (goal_reached) 
            f = 0;  // If goal is reached, cost is zero
        else 
            f = g + h;  // else calculate f = g + h
    end
endmodule