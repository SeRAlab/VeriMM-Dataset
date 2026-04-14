module phase_shifter (
    input wire clk,
    input wire [2:0] phase_in,
    output reg [2:0] phase_out
);
    reg [2:0] shift_reg [0:3]; // 4-stage shift register

    always @(posedge clk) begin
        // Shift the input phase through the register
        shift_reg[0] <= phase_in;           // Input phase
        shift_reg[1] <= shift_reg[0];       // First stage delay
        shift_reg[2] <= shift_reg[1];       // Second stage delay
        shift_reg[3] <= shift_reg[2];       // Third stage delay
        phase_out <= shift_reg[3];          // Output the last stage
    end
endmodule