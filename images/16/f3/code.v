module astar_heuristic (  
    input [7:0] g,  
    input [7:0] h,  
    output [8:0] f  
);  
    assign f = g + h;  
endmodule