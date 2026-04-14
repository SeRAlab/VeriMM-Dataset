module piso_shift_register (
    input [7:0] d,
    input clk,
    input load,
    output reg q);
reg [7:0] shift_reg;
always @(posedge clk) begin
    if (load)
        shift_reg <= d;
    else
        shift_reg <= {shift_reg[6:0], 1'b0};
    q <= shift_reg[7];
end
endmodule