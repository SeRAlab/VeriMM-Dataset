module top_module(
    input [3:0] data_in,
    input ctrl,
    output [1:0] data_out
);wire [1:0] and_result;

assign and_result[1] = data_in[3] & data_in[2];
assign and_result[0] = ctrl ? ~(and_result[1]) : and_result[1];
assign data_out = and_result;

endmodule