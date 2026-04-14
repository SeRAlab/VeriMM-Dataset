module digital_phase_shifter(
    input [3:0] phase_in,
    input [1:0] control,
    output reg [3:0] phase_out
);
    always @(*) begin
        case(control)
            2'b00: phase_out = phase_in;                   // No shift
            2'b01: phase_out = {phase_in[2:0], phase_in[3]}; // Left shift by 1
            2'b10: phase_out = {phase_in[1:0], phase_in[3:2]}; // Left shift by 2
            2'b11: phase_out = {phase_in[0], phase_in[3:1]}; // Left shift by 3
            default: phase_out = phase_in;                 // Default case
        endcase
    end
endmodule