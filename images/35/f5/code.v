module AStarCostCalculator(  
    input [31:0] g,  // Current cost  
    input [31:0] h,  // Heuristic cost  
    output [31:0] f   // Estimated total cost  
);  
    assign f = g + h;  
endmodule