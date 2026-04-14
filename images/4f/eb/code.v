module top_module(
    input in0,
    input in1,
    input ctrl,
    output out
);wire not_ctrl;
assign not_ctrl = ~ctrl;

assign out = (in0 & not_ctrl) | (in1 & ctrl);

endmodule