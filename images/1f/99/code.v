module voltage_regulator(
    input wire [7:0] Vin,
    output wire [7:0] Vout
);
    assign Vout = (Vin >= 8'd50) ? 8'd30 : 8'd0; // Output 30 if Vin >= 50, else 0
endmodule