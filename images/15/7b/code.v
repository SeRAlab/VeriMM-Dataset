module siso_shift_register (
    input clk,
    input rst,
    input serial_in,
    output reg serial_out
);
    reg [4:0] shift_reg; // 5-bit shift register

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            shift_reg <= 5'b00000; // Reset the shift register to 0
            serial_out <= 0; // Ensure output is also reset
        end else begin
            shift_reg <= {shift_reg[3:0], serial_in}; // Shift left and insert serial input
            serial_out <= shift_reg[4]; // Output the most significant bit
        end
    end
endmodule