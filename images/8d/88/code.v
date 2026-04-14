module top_module(
    input  wire [63:0] data_in,
    input  wire [7:0]  ctrl_in,
    output wire [72:0] data_out
);assign data_out[7:0]   = data_in[7:0];
assign data_out[8]     = ctrl_in[0];
assign data_out[16:9]  = data_in[15:8];
assign data_out[17]    = ctrl_in[1];
assign data_out[25:18] = data_in[23:16];
assign data_out[26]    = ctrl_in[2];
assign data_out[34:27] = data_in[31:24];
assign data_out[35]    = ctrl_in[3];
assign data_out[43:36] = data_in[39:32];
assign data_out[44]    = ctrl_in[4];
assign data_out[52:45] = data_in[47:40];
assign data_out[53]    = ctrl_in[5];
assign data_out[61:54] = data_in[55:48];
assign data_out[62]    = ctrl_in[6];
assign data_out[70:63] = data_in[63:56];
assign data_out[71]    = ctrl_in[7];
assign data_out[72]    = 1'b0;

endmodule