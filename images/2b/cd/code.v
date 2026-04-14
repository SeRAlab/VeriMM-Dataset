module power_gating (
    input wire ctrl,
    input wire [7:0] data,
    output wire [7:0] power_out
);

assign power_out = (ctrl) ? data : 8'b00000000;

endmodule