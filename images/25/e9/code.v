module power_gating (
    input wire data_in,
    input wire power_ctl,
    output wire data_out
);
    assign data_out = power_ctl ? data_in : 1'b0;
endmodule