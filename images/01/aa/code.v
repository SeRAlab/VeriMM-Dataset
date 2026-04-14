module SISO_Shift_Register (
    input wire clk,
    input wire data_in,
    output reg data_out
);
    reg [3:0] shift_reg;

    always @(posedge clk) begin
        shift_reg <= {shift_reg[2:0], data_in}; // Shift left and insert data_in
        data_out <= shift_reg[3]; // Output the most significant bit
    end
endmodule