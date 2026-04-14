module phase_shifter (
    input [2:0] phase_in,
    input [1:0] control,
    output reg [2:0] phase_out
);
    always @(*) begin
        case (control)
            2'b00: phase_out = phase_in; // No shift
            2'b01: phase_out = (phase_in + 3'b001) % 8; // 90-degree shift
            2'b10: phase_out = (phase_in + 3'b010) % 8; // 180-degree shift
            2'b11: phase_out = (phase_in + 3'b011) % 8; // 270-degree shift
            default: phase_out = phase_in; // Default case
        endcase
    end
endmodule