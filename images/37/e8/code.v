module phase_shifter (
    input clk,
    input [1:0] control,
    output reg shifted_signal
);
    reg [1:0] state;

    always @(posedge clk) begin
        state <= control;
    end

    always @(posedge clk) begin
        case (state)
            2'b00: shifted_signal <= shifted_signal; // No shift
            2'b01: shifted_signal <= ~shifted_signal; // 90-degree shift (inverted signal)
            2'b10: shifted_signal <= shifted_signal; // 180-degree shift (same signal)
            2'b11: shifted_signal <= ~shifted_signal; // 270-degree shift (inverted signal)
            default: shifted_signal <= shifted_signal; // Default case
        endcase
    end
endmodule