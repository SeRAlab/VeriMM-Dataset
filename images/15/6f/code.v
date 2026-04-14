module power_gating (
    input wire enable,
    output wire power
);
    assign power = enable ? 1'b1 : 1'b0;
endmodule