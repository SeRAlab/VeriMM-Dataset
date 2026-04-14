module shift_register(
    input clk,
    input rst,
    input shift_dir,
    input shift_in,
    output reg [7:0] shift_out
);

reg [7:0] shift_reg;

always @(posedge clk) begin
    if (rst)
        shift_reg <= 8'b00000000;
    else if (shift_dir)
        shift_reg <= {shift_reg[6:0], shift_in};
    else
        shift_reg <= {shift_in, shift_reg[7:1]};
end

assign shift_out = shift_reg;

endmodule