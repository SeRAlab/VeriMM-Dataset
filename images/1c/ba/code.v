module voltage_sensor (
    input [7:0] Vin,
    input [7:0] Vref,
    output Vout
);
    assign Vout = (Vin > Vref) ? 1'b1 : 1'b0;
endmodule