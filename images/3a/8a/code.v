module bluetooth_signal_decoder(
    input [4:0] signal_strength,
    output reg [2:0] signal_quality
);

always @(*) begin
    if (signal_strength <= 5'd7) begin
        signal_quality = 3'b000; // Poor
    end else if (signal_strength <= 5'd15) begin
        signal_quality = 3'b001; // Fair
    end else if (signal_strength <= 5'd23) begin
        signal_quality = 3'b010; // Good
    end else begin
        signal_quality = 3'b011; // Excellent
    end
end

endmodule