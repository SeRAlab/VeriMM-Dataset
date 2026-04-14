module top_module(
    input clk,
    input reset,
    input new_bit,
    output reg [3:0] shift_reg);always @(posedge clk) begin
    if (reset)
        shift_reg <= 4'b0;
    else
        shift_reg <= {shift_reg[2:0], new_bit};
end
endmodule