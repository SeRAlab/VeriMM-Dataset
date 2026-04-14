module siso_shift_register (
    input clk,
    input reset,
    input data_in,
    output reg data_out
);
    reg [4:0] shift_reg; // 5-bit shift register

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            shift_reg <= 5'b0; // clear the register on reset
            data_out <= 1'b0;
        end else begin
            data_out <= shift_reg[0]; // output the least significant bit
            shift_reg <= {data_in, shift_reg[4:1]}; // shift in the new data
        end
    end
endmodule