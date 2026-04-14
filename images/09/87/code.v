module wifi_signal_quality (
    input [4:0] signal_strength,
    output reg [2:0] signal_quality
);
    always @* begin
        if (signal_strength > 31) begin
            signal_quality = 3'b111; // Error condition
        end else if (signal_strength <= 10) begin
            signal_quality = 3'b000; // Low quality
        end else if (signal_strength <= 20) begin
            signal_quality = 3'b001; // Medium quality
        end else begin
            signal_quality = 3'b010; // High quality
        end
    end
endmodule