module LDO_Controller (
    input [4:0] Vin,
    input enable,
    output reg [4:0] Vout
);
    parameter MAX_VOLTAGE = 5'b11111; // Maximum voltage is 31

    always @(*) begin
        if (enable) begin
            if (Vin > MAX_VOLTAGE)
                Vout = MAX_VOLTAGE; // Clamp Vout to MAX_VOLTAGE
            else
                Vout = Vin; // Pass through Vin
        end else begin
            Vout = 5'b00000; // Output 0 when not enabled
        end
    end
endmodule