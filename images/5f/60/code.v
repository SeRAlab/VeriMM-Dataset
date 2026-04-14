module top_module(
    input [7:0] a,
    input [7:0] b,
    input sel,
    output [7:0] s,
    output overflow
);wire [7:0] xor_out;
wire [7:0] add_out;
wire carry_out;

// Define the XOR operation using an operator instead of a module.
assign xor_out = a ^ b;

// Implement a simple 8-bit adder with carry output.
wire [8:0] full_adder_out;
assign full_adder_out = {1'b0, a} + {1'b0, b} + sel;
assign add_out = full_adder_out[7:0];
assign carry_out = full_adder_out[8];

// Select between the XOR and adder output.
assign s = sel ? add_out : xor_out;
assign overflow = sel ? carry_out : 0;

endmodule