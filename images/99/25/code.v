module mux_2to1#(
    parameter width = 8
)(
    input               sel,
    input   [width-1:0] input0,
    input   [width-1:0] input1,
    
    output  [width-1:0] mux_out
);

assign mux_out = sel ? input1 : input0;

endmodule