module top_module(
    input [3:0] data,
    input [3:0] shift_amount,
    input shift_left,
    output [3:0] result
);assign result = shift_left ? data << shift_amount : data >> shift_amount;

endmodule