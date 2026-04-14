module power_gating(
    input wire enable,
    input wire [3:0] data_in,
    output wire [3:0] data_out
);
    assign data_out = enable ? data_in : 4'b0000;
endmodule