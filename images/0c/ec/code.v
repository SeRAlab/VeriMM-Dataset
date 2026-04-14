module LDO (
    input wire [7:0] Vref,  // Reference voltage input
    input wire EN,          // Enable signal
    input wire [7:0] Vin,   // Input voltage
    output reg [7:0] Vout   // Regulated output voltage
);

always @(*) begin
    if (EN) begin
        Vout = Vref; // Output Vref when enabled
    end else begin
        Vout = Vin; // Output Vin when disabled
    end
    // Ensure Vout does not exceed Vin
    if (Vout > Vin) begin
        Vout = Vin;
    end
end

endmodule