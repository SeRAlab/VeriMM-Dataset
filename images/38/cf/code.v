module voltage_comparator (
    input wire [7:0] V_in,     // 8-bit input voltage
    input wire [7:0] V_ref,    // 8-bit reference voltage
    output wire V_out          // output high if V_in > V_ref
);
    assign V_out = (V_in > V_ref) ? 1'b1 : 1'b0;
endmodule