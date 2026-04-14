module top_module(
    input [3:0] data_in,
    input [1:0] shift_amount,
    output [3:0] data_out
);wire [3:0] shifted_data;

assign shifted_data[0] = (shift_amount == 2'b00) ? data_in[0] : ((shift_amount == 2'b01) ? data_in[1] : ((shift_amount == 2'b10) ? data_in[2] : data_in[3]));
assign shifted_data[1] = (shift_amount == 2'b00) ? data_in[1] : ((shift_amount == 2'b01) ? data_in[2] : ((shift_amount == 2'b10) ? data_in[3] : data_in[0]));
assign shifted_data[2] = (shift_amount == 2'b00) ? data_in[2] : ((shift_amount == 2'b01) ? data_in[3] : ((shift_amount == 2'b10) ? data_in[0] : data_in[1]));
assign shifted_data[3] = (shift_amount == 2'b00) ? data_in[3] : ((shift_amount == 2'b01) ? data_in[0] : ((shift_amount == 2'b10) ? data_in[1] : data_in[2]));

assign data_out = shifted_data;

endmodule