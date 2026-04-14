module power_gating (
    input wire enable,
    input wire power_request,
    output wire power_supply
);
    assign power_supply = enable & power_request;
endmodule