module SISO_Shift_Register (
    input wire clk,
    input wire rst,
    input wire serial_in,
    output reg serial_out
);
    reg [4:0] shift_reg;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            shift_reg <= 5'b00000;
            serial_out <= 1'b0;
        end else begin
            shift_reg <= {shift_reg[3:0], serial_in}; // Shift left and input new bit
            serial_out <= shift_reg[4]; // Output the last bit of shift register
        end
    end
endmodule