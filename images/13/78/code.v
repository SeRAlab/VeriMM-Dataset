module phase_shifter (
    input [2:0] phase_in,
    output reg [2:0] phase_out
);
    always @(*) begin
        case (phase_in)
            3'b000: phase_out = 3'b000;
            3'b001: phase_out = 3'b010;
            3'b010: phase_out = 3'b100;
            3'b011: phase_out = 3'b110;
            3'b100: phase_out = 3'b001;
            3'b101: phase_out = 3'b011;
            3'b110: phase_out = 3'b101;
            3'b111: phase_out = 3'b111;
            default: phase_out = 3'bxxx; // Undefined state
        endcase
    end
endmodule