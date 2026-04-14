module top_module(a, b, out);input [15:0] a, b;
    output [15:0] out;
    
    assign out = a & b;

endmodule