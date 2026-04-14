module power_gating (
    input wire [3:0] data_in,
    input wire control,
    output wire [3:0] data_out
);
    assign data_out = control ? data_in : 4'b0000;
endmodule