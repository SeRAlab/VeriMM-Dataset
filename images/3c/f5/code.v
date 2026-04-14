module phase_shifter (
    input [2:0] phase_in,
    input [1:0] select,
    output reg [2:0] phase_out
);

always @(*) begin
    case (select)
        2'b00: phase_out = phase_in; // No shift
        2'b01: phase_out = phase_in + 3'b001; // 45 degrees
        2'b10: phase_out = phase_in + 3'b010; // 90 degrees
        2'b11: phase_out = phase_in + 3'b011; // 135 degrees
        default: phase_out = phase_in; // Default case
    endcase
end

endmodule