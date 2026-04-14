module power_gating (
    input enable,
    input control,
    output power
);
    assign power = enable & control;
endmodule