module LDO_Regulator (
    input wire [7:0] Vin,  // Input voltage (8-bit)
    input wire enable,      // Enable signal
    output reg [7:0] Vout   // Output voltage (8-bit)
);

always @(*) begin
    if (enable) begin
        if (Vin >= 8'd50) begin
            Vout = 8'd50; // Regulate output to 50 if input is >= 50
        end else if (Vin >= 8'd30) begin
            Vout = 8'd30; // Regulate output to 30 if input is >= 30
        end else if (Vin >= 8'd10) begin
            Vout = 8'd10; // Regulate output to 10 if input is >= 10
        end else begin
            Vout = 8'd0;  // Output 0 if input is < 10
        end
    end else begin
        Vout = 8'd0; // If not enabled, output is 0
    end
end

endmodule