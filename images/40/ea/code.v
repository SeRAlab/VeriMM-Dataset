module phase_shifter(
    input [1:0] phase_in,
    output reg [1:0] phase_out
);

always @(*) begin
    case (phase_in)
        2'b00: phase_out = 2'b00; // 00 -> 00
        2'b01: phase_out = 2'b10; // 01 -> 10
        2'b10: phase_out = 2'b11; // 10 -> 11
        2'b11: phase_out = 2'b00; // 11 -> 00
        default: phase_out = 2'b00; // Default case
    endcase
end

endmodule