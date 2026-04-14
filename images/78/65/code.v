module top_module(a, b, d);input [63:0] a, b;
    output [63:0] d;
    
    assign d = a + b;
endmodule