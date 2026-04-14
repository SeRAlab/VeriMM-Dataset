module siso_shift_register (
    input wire CLK,
    input wire RST,
    input wire SI,
    output reg SO
);
    reg [3:0] shift_reg; // 4-bit shift register

    always @(posedge CLK or posedge RST) begin
        if (RST) begin
            shift_reg <= 4'b0000; // Clear the register on reset
            SO <= 1'b0;           // Ensure SO is also cleared
        end else begin
            SO <= shift_reg[0];   // Shift out the oldest bit
            shift_reg <= {SI, shift_reg[3:1]}; // Shift in the new bit
        end
    end
endmodule