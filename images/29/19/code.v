module LDO_Regulator (
    input wire enable,
    input wire [7:0] Vin,     // Input voltage (8-bit)
    input wire [7:0] Vfb,     // Feedback voltage (8-bit)
    output reg [7:0] Vout     // Output voltage (8-bit)
);

    always @(*) begin
        if (enable) begin
            if (Vin >= Vfb) begin
                Vout = Vfb;  // Regulate output to feedback voltage
            end else begin
                Vout = Vin;   // Allow input voltage to pass if it's less than feedback
            end
        end else begin
            Vout = 8'b00000000;  // Output is 0 when disabled
        end
    end
endmodule