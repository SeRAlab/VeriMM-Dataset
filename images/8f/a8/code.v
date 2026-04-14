module priority_encoder_4bit(
    input [3:0] in,       // 4-bit input lines.
    output reg [1:0] out, // 2-bit binary output.
    output reg valid      // Valid signal indicating whether any input is active.
);

always @(*)
begin
    valid = (in != 4'b0000);   // Valid signal is 1 if any input is active.
    case (in)
        4'b1000: out = 2'b11;  // Highest priority for input[3].
        4'b0100: out = 2'b10;  // Next priority for input[2].
        4'b0010: out = 2'b01;  // Next priority for input[1].
        4'b0001: out = 2'b00;  // Lowest priority for input[0].
        default: out = 2'b00;  // Default case.
    endcase
end

endmodule