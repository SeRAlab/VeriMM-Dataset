module PitchDetector(
    input wire clk,
    input wire reset,
    input wire [3:0] voice_signal,
    output reg [6:0] detected_pitch
);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        detected_pitch <= 7'b0000000;
    end else begin
        case (voice_signal)
            4'b0000: detected_pitch <= 7'b0000001; // Pitch 1
            4'b0001: detected_pitch <= 7'b0000010; // Pitch 2
            4'b0010: detected_pitch <= 7'b0000100; // Pitch 3
            4'b0011: detected_pitch <= 7'b0001000; // Pitch 4
            4'b0100: detected_pitch <= 7'b0010000; // Pitch 5
            4'b0101: detected_pitch <= 7'b0100000; // Pitch 6
            default: detected_pitch <= 7'b0000000; // No pitch detected
        endcase
    end
end

endmodule