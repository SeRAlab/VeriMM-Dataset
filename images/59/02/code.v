module top_module(
    input [31:0] a,
    input [31:0] b,
    output [31:0] out
);// Bitwise AND operation
    assign out = a & b;
    
    // Reverse byte ordering
    assign out = {out[7:0], out[15:8], out[23:16], out[31:24]};
    
endmodule