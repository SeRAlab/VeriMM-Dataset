module top_module(
    input [31:0] data,
    input [4:0] shift_amount,
    input shift_direction,
    output [31:0] shifted_data
);assign shifted_data = shift_direction ? data << shift_amount : data >> shift_amount;

endmodule