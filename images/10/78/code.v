module LDO (
    input wire [4:0] Vin,
    input wire en,
    output wire [4:0] Vout
);
    parameter Vref = 5'b01101; // Reference voltage: 13 in decimal

    assign Vout = (en) ? ((Vin > Vref) ? Vref : Vin) : 5'b00000;
endmodule