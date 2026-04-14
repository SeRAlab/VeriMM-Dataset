module siso_shift_register (
    input wire clk,
    input wire reset,
    input wire serial_in,
    output reg serial_out
);
    reg [4:0] shift_reg; // 5-bit shift register

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            shift_reg <= 5'b00000; // Clear the register
        end else begin
            shift_reg <= {shift_reg[3:0], serial_in}; // Shift left and insert new bit
        end
    end

    always @(posedge clk) begin
        serial_out <= shift_reg[4]; // Output the MSB
    end
endmodule