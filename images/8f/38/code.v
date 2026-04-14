module top_module(
    input [3:0] A,
    input [3:0] B,
    output [3:0] sum,
    output carry_out
);wire [3:0] xor_out;
    wire [3:0] and_out;
    wire [3:0] or_out;
    
    assign xor_out = A ^ B;
    assign and_out = A & B;
    assign sum = xor_out ^ or_out;
    assign or_out = {1'b0, and_out[3], and_out[2], and_out[1]} | {and_out[3], and_out[2], and_out[1], and_out[0]};
    assign carry_out = or_out[3];

endmodule