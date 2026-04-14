module power_gating(
    input wire enable,
    input wire power,
    output wire supply
);
    assign supply = enable ? power : 0;
endmodule