module LDO (
    input wire [7:0] Vin,
    input wire [7:0] Vref,
    output wire [7:0] Vout
);
    assign Vout = (Vin > Vref) ? Vref : Vin;
endmodule