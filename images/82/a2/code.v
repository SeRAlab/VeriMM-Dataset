module top_module(
    input [WIDTH-1:0] IN0,
    input [WIDTH-1:0] IN1,
    input SEL,
    output [WIDTH-1:0] OUT
);parameter WIDTH = 8;

assign OUT = SEL ? IN1 : IN0;

endmodule