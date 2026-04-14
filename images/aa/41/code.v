module top_module(input wire [3:0] n, input wire [10:0] data_in, output wire [10:0] data_out);wire [10:0] data_out3;
wire [10:0] data_out2;
wire [10:0] data_out1;
assign data_out3 = (n[3] == 1) ? {data_in[7:0], data_in[10:8]} : data_in;
assign data_out2 = (n[2] == 1) ? {data_out3[3:0], data_out3[10:4]} : data_out3;
assign data_out1 = (n[1] == 1) ? {data_out2[1:0], data_out2[10:2]} : data_out2;
assign data_out = (n[0] == 1) ? {data_out1[0], data_out1[10:1]} : data_out1;endmodule