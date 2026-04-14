module top_module(
    input [2:0] op,
    input [15:0] a,
    input [15:0] b,
    output [15:0] out
);wire [15:0] not_a;
assign not_a = ~a;

wire [15:0] and_result;
assign and_result = a & b;

wire [15:0] or_result;
assign or_result = a | b;

wire [15:0] xor_result;
assign xor_result = a ^ b;

wire [15:0] left_shift_result;
assign left_shift_result = a << b[3:0];

wire [15:0] right_shift_result;
assign right_shift_result = a >> b[3:0];

assign out = (op == 0) ? and_result :
             (op == 1) ? or_result :
             (op == 2) ? xor_result :
             (op == 3) ? not_a :
             (op == 4) ? left_shift_result :
                         right_shift_result;

endmodule