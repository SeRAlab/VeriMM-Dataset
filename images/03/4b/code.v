module SISO_Shift_Register (
    input clk,
    input reset,
    input serial_in,
    output reg serial_out
);
    reg [4:0] shift_reg; // 5-bit shift register

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            shift_reg <= 5'b00000; // reset shift register to 0
            serial_out <= 1'b0;     // reset output to 0
        end else begin
            serial_out <= shift_reg[0]; // output the oldest bit
            shift_reg <= {serial_in, shift_reg[4:1]}; // shift left and input serial bit
        end
    end
endmodule