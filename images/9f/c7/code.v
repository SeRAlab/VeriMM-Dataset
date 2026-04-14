module top_module(
    input [15:0] a,
    input [15:0] b,
    input [15:0] c,
    input sel,
    output [15:0] out,
    output equal
);wire [15:0] larger;
    assign larger = (a > b) ? a : b;
    
    assign out = (sel == 1'b0) ? larger : c;
    
    assign equal = (a == b) ? 1'b1 : 1'b0;
    
endmodule