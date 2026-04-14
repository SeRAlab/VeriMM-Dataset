module siso_shift_register (
    input clk,
    input rst,
    input serial_in,
    output reg serial_out
);
    reg [4:0] shift_reg; // 5-bit shift register

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            shift_reg <= 5'b00000; // clear the shift register
            serial_out <= 1'b0;     // clear the output
        end else begin
            serial_out <= shift_reg[0]; // output the oldest bit
            shift_reg <= {serial_in, shift_reg[4:1]}; // shift in the new bit
        end
    end
endmodule