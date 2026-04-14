module bluetooth_signal_strength (
    input [3:0] signal_strength,
    output reg [2:0] strength_indicator
);
    always @(*) begin
        if (signal_strength <= 4) begin
            strength_indicator = 3'b000; // Low
        end else if (signal_strength <= 10) begin
            strength_indicator = 3'b001; // Medium
        end else begin
            strength_indicator = 3'b010; // High
        end
    end
endmodule