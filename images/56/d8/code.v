module demux_1to2 (
    input wire I,
    input wire S,
    output wire [1:0] Y
    );

assign Y[0] = I & ~S;
assign Y[1] = I &  S;

endmodule