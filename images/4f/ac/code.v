module top_module(
    i_op,
    i_wf_in,
    i_wk,
    o_wf_out
);input i_op;
input [63:0] i_wf_in;
input [31:0] i_wk;
output [63:0] o_wf_out;

wire [7:0] add8;
wire [7:0] sub8;

assign add8 = i_wf_in[7:0] + i_wk[7:0];
assign sub8 = i_wf_in[7:0] - i_wk[7:0];

assign o_wf_out[63:56] = i_wf_in[63:56];
assign o_wf_out[55:48] = i_wf_in[55:48] ^ i_wk[31:24];
assign o_wf_out[47:40] = i_wf_in[47:40];

assign o_wf_out[39:32] = (i_op == 0) ? (i_wf_in[39:32] + i_wk[23:16]) : (i_wf_in[39:32] - i_wk[23:16]);

assign o_wf_out[31:24] = i_wf_in[31:24];

assign o_wf_out[23:16] = i_wf_in[23:16] ^ i_wk[15:8];

assign o_wf_out[15:8] = i_wf_in[15:8];

assign o_wf_out[7:0] = (i_op == 0) ? add8 : sub8;

endmodule