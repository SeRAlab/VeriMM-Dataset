module linear_voltage_regulator(
    input wire [7:0] Vin,       // 8-bit input voltage
    input wire [7:0] Vref,      // 8-bit reference voltage
    output reg [7:0] Vout       // 8-bit output voltage
);
    always @(*) begin
        if (Vin > Vref) begin
            Vout = Vref;          // output is Vref if input is greater than reference
        end else begin
            Vout = 8'b0;          // output is zero if input is less than or equal to reference
        end
    end
endmodule