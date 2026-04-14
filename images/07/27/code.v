module phase_shifter (
    input wire clk,
    input wire rst,
    input wire [4:0] phase_in,
    input wire [1:0] shift_amount, // 00 = 0 bits, 01 = 1 bit, 10 = 2 bits, 11 = 3 bits
    output reg [4:0] phase_out
);
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            phase_out <= 5'b00000;
        end else begin
            case (shift_amount)
                2'b00: phase_out <= phase_in; // No shift
                2'b01: phase_out <= {phase_in[3:0], phase_in[4]}; // Shift left by 1
                2'b10: phase_out <= {phase_in[2:0], phase_in[4:3]}; // Shift left by 2
                2'b11: phase_out <= {phase_in[1:0], phase_in[4:2]}; // Shift left by 3
                default: phase_out <= phase_in; // Default case
            endcase
        end
    end
endmodule