module power_gating(
    input enable,
    input control,
    output power_gated
);
    assign power_gated = enable ? control : 1'b0;
endmodule