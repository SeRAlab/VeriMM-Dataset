module siso_shift_register(
    input clk,
    input reset,
    input serial_in,
    output reg serial_out
);
    reg [4:0] shift_reg; // 5-bit shift register

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            shift_reg <= 5'b00000; // Reset the shift register
            serial_out <= 1'b0; // Reset output
        end else begin
            shift_reg <= {shift_reg[3:0], serial_in}; // Shift right and load new bit
            serial_out <= shift_reg[4]; // Output the last bit
        end
    end
endmodule