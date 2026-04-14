module pitch_detector (
    input [4:0] frequency,
    output reg [2:0] pitch_class
);
    always @(*) begin
        case (frequency[2:0])
            3'b000: pitch_class = 3'b000; // C
            3'b001: pitch_class = 3'b001; // C#
            3'b010: pitch_class = 3'b010; // D
            3'b011: pitch_class = 3'b011; // D#
            3'b100: pitch_class = 3'b100; // E
            3'b101: pitch_class = 3'b101; // F
            3'b110: pitch_class = 3'b110; // F#
            3'b111: pitch_class = 3'b111; // G
            default: pitch_class = 3'bxxx; // Undefined
        endcase
    end
endmodule