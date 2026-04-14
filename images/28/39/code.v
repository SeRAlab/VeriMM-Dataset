module phase_shifter(
    input [4:0] phase_in,
    input [2:0] shift_amount, // 3-bit input to allow shift from 0 to 7
    output reg [4:0] phase_out
);
    
    always @(*) begin
        case (shift_amount)
            3'b000: phase_out = phase_in; // No shift
            3'b001: phase_out = {phase_in[3:0], phase_in[4]}; // Shift left by 1
            3'b010: phase_out = {phase_in[2:0], phase_in[4:3]}; // Shift left by 2
            3'b011: phase_out = {phase_in[1:0], phase_in[4:2]}; // Shift left by 3
            3'b100: phase_out = {phase_in[0], phase_in[4:1]}; // Shift left by 4
            3'b101: phase_out = {phase_in[4:1]}; // Shift left by 5 (same as no shift)
            3'b110: phase_out = {phase_in[4:2], phase_in[4:3]}; // Shift left by 6
            3'b111: phase_out = {phase_in[4:3], phase_in[4:2]}; // Shift left by 7
            default: phase_out = phase_in; // Default case
        endcase
    end

endmodule