module top_module(
    input wire [2:0] in_vec,
    input wire sel,
    output wire [2:0] out_vec,
    output wire o2,
    output wire o1,
    output wire o0
);wire [2:0] mux_out;
wire in_0, in_1, in_2;

assign in_0 = in_vec[0];
assign in_1 = in_vec[1];
assign in_2 = in_vec[2];

assign o0 = in_0;
assign o1 = in_1;
assign o2 = in_2;

assign mux_out = sel ? in_vec[2:1] : in_vec[1:0];

assign out_vec[0] = mux_out[0] | in_0;
assign out_vec[1] = mux_out[1] | in_1;
assign out_vec[2] = mux_out[2] | in_2;

endmodule