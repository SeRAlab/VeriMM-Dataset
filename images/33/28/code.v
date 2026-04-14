module SISO_Shift_Register (
    input wire SI,
    input wire CLK,
    input wire RST,
    output reg SO
);
    reg [3:0] shift_reg; // 4-bit shift register

    always @(posedge CLK or posedge RST) begin
        if (RST) begin
            shift_reg <= 4'b0000; // Reset to 0
            SO <= 1'b0; // Initialize output
        end else begin
            SO <= shift_reg[3]; // Output the MSB
            shift_reg <= {shift_reg[2:0], SI}; // Shift left and input new data
        end
    end
endmodule