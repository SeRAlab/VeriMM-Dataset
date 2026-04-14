module top_module(
    input [3:0] in,
    output [3:0] out
);wire [3:0] inverted;
    wire [3:0] one = 4'b0001;
    
    assign inverted = ~in + 1;
    
    assign out = (in < 0) ? inverted : in;

endmodule