module arithmetic_shift_register (
    input clk,
    input load,
    input shift,
    input [7:0] data_in,
    output [7:0] q );reg [7:0] shift_reg;

always @(posedge clk) begin
    if (load)
        shift_reg <= data_in;
    else if (shift)
        shift_reg <= {shift_reg[6:0], 1'b0};
end

assign q = shift_reg;

endmodule