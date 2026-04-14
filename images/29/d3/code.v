module ldo_regulator(
    input wire enable,
    input wire [7:0] vin,   // 8-bit input voltage
    output reg [7:0] vout   // 8-bit output voltage
);

parameter DROP_OUT_VOLTAGE = 8'd1; // Dropout voltage of 1V

always @(*) begin
    if (enable) begin
        if (vin > DROP_OUT_VOLTAGE) begin
            vout = vin - DROP_OUT_VOLTAGE; // Apply dropout
        end else begin
            vout = 8'd0; // Output is zero if vin <= dropout voltage
        end
    end else begin
        vout = 8'd0; // Output is zero if disabled
    end
end

endmodule