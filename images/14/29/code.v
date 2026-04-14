module phase_shifter (
    input [2:0] phase_in,
    input [1:0] control,
    output reg [2:0] phase_out
);
    always @(*) begin
        case (control)
            2'b00: phase_out = phase_in;               // 0 degree shift
            2'b01: phase_out = {phase_in[1:0], phase_in[2]}; // 90 degree shift
            2'b10: phase_out = {phase_in[2:0] >> 1};         // 180 degree shift
            2'b11: phase_out = {phase_in[0], phase_in[2:1]}; // 270 degree shift
            default: phase_out = phase_in;               // default case
        endcase
    end
endmodule