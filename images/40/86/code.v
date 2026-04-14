module astar_heuristic (
    input [7:0] g, // g cost
    input [7:0] h, // h cost
    output [7:0] f  // f cost
);
    assign f = g + h;
endmodule