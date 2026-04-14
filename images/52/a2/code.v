module top_module(
    input [15:0] data_in,
    input [3:0] shift_amount,
    output [15:0] data_out
);assign data_out = (shift_amount[3]) ? 16'b0 : data_in >> shift_amount;
    assign data_out = (shift_amount[3]) ? data_in << (~shift_amount + 1) : data_out;

endmodule