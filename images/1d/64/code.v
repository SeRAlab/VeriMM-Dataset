module ldo_regulator (
    input [4:0] Vin,      // Input voltage (5 bits)
    input enable,         // Enable signal
    output reg [4:0] Vout // Output voltage (5 bits)
);
    // Fixed dropout voltage of 1V (1 in 5-bit format)
    parameter DROP_OUT = 5'b00001;

    always @(*) begin
        if (enable) begin
            if (Vin >= DROP_OUT) begin
                Vout = Vin - DROP_OUT; // Vout = Vin - 1V
            end else begin
                Vout = 5'b00000; // If Vin < DROP_OUT, Vout = 0V
            end
        end else begin
            Vout = 5'b00000; // If not enabled, Vout = 0V
        end
    end
endmodule