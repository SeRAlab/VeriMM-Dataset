module voltage_regulator (
    input wire [7:0] V_in,
    input wire [7:0] V_ref,
    output wire [7:0] V_out
);
    assign V_out = (V_in > V_ref) ? V_ref : V_in;
endmodule