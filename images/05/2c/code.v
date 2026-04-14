module wifi_signal_strength (
    input wire clk,
    input wire rst,
    input wire signed [7:0] signal_strength, // 8-bit signed input for dBm
    output reg [2:0] strength_category // 3-bit output for strength category
);
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            strength_category <= 3'b000; // Default to very weak
        end else begin
            if (signal_strength < -80) begin
                strength_category <= 3'b000; // Very weak
            end else if (signal_strength >= -80 && signal_strength < -70) begin
                strength_category <= 3'b001; // Weak
            end else if (signal_strength >= -70 && signal_strength < -60) begin
                strength_category <= 3'b010; // Moderate
            end else if (signal_strength >= -60 && signal_strength < -50) begin
                strength_category <= 3'b011; // Strong
            end else begin
                strength_category <= 3'b100; // Very strong
            end
        end
    end
endmodule