module fir_filter (
    input [4:0] x,              // 5-bit input signal
    input clk,                  // Clock signal
    output reg [4:0] y          // 5-bit output signal
);
    reg [4:0] shift_reg [0:4];  // Shift register to hold past inputs
    integer i;

    always @(posedge clk) begin
        // Shift the input values into the shift register
        shift_reg[0] <= x; // New input
        for (i = 1; i < 5; i = i + 1) begin
            shift_reg[i] <= shift_reg[i-1];
        end
        
        // Compute the output based on the FIR coefficients
        y <= (shift_reg[0] * 1) + 
             (shift_reg[1] * 2) + 
             (shift_reg[2] * 3) + 
             (shift_reg[3] * 4) + 
             (shift_reg[4] * 5);
    end
endmodule