module siso_shift_register (
    input clk,
    input reset,
    input data_in,
    output reg data_out
);

    reg [4:0] shift_reg; // 5-bit shift register

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            shift_reg <= 5'b00000; // Reset shift register to 0
            data_out <= 0;
        end else begin
            shift_reg <= {shift_reg[3:0], data_in}; // Shift left and insert data_in
            data_out <= shift_reg[4]; // Output the last bit of the shift register
        end
    end
endmodule