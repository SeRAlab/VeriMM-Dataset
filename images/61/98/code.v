module top_module(
    input wire [2:0] vec,
    output wire [2:0] outv,
    output wire o2,
    output wire o1,
    output wire o0
);wire inv_o0, inv_o2;

assign inv_o0 = ~o0;
assign inv_o2 = ~o2;

assign o0 = vec[1];
assign o1 = vec[2];
assign o2 = vec[0];

assign outv = vec;

assign o0 = inv_o0 ? vec[2] : vec[1];
assign o2 = inv_o2 ? vec[1] : vec[2];

endmodule