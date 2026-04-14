module SISO_Shift_Register (
    input clk,
    input rst,
    input serial_in,
    output reg serial_out
);
    reg [4:0] shift_reg; // 5-bit shift register

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            shift_reg <= 5'b0; // Reset the shift register
            serial_out <= 1'b0; // Reset the output
        end else begin
            serial_out <= shift_reg[0]; // Output the least significant bit
            shift_reg <= {serial_in, shift_reg[4:1]}; // Shift the new bit in
        end
    end
endmodule