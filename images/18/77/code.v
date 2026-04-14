module SISO_Shift_Register (
    input wire clk,
    input wire reset,
    input wire data_in,
    output reg data_out
);

    reg [3:0] shift_reg;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            shift_reg <= 4'b0000; // clear the register
            data_out <= 1'b0;
        end else begin
            shift_reg <= {shift_reg[2:0], data_in}; // shift left and insert new data_in
            data_out <= shift_reg[3]; // output the last bit of the shift register
        end
    end

endmodule