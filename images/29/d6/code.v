module AStarHeuristic (
    input [3:0] g,
    input [3:0] h,
    output [4:0] f
);
    assign f = g + h;
endmodule