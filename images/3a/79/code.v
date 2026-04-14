module voltage_regulator(
    input [7:0] Vin,  // 8-bit input voltage
    output [7:0] Vout // 8-bit output voltage
);
    assign Vout = Vin >> 1; // Output is half of the input
endmodule