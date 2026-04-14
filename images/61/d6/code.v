module top_module( 
    input [99:0] in,
    output out_and,
    output out_or,
    output out_xor 
);wire [99:0] nor_and;
wire [99:0] nor_or;
wire [99:0] nor_xor;

// NOR gate for AND operation
assign nor_and = ~&in;

// NOR gate for OR operation
assign nor_or = ~|in;

// NOR gate for XOR operation
assign nor_xor = ~(in ^ 100'b1);

// Output ports
assign out_and = ~&nor_and;
assign out_or = ~&nor_or;
assign out_xor = ~&nor_xor;

endmodule