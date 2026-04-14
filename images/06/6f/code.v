module SISO_Shift_Register (
    input clk,
    input rst,
    input si,         // Serial input
    output reg so     // Serial output
);
    reg [4:0] shift_reg; // 5-bit shift register
    integer i;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            shift_reg <= 5'b00000; // Reset the shift register
            so <= 1'b0;
        end else begin
            shift_reg <= {shift_reg[3:0], si}; // Shift in a new bit
            so <= shift_reg[4]; // Output the most significant bit
        end
    end
endmodule