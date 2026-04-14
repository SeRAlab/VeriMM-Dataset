module top_module(
    input clk,
    input reset,
    input load,
    input [7:0] data,
    output reg out);reg [7:0] shift_reg;

always @(posedge clk) begin
    if (reset)
        shift_reg <= 8'b0;
    else if (load)
        shift_reg <= data;
    else
        shift_reg <= {shift_reg[6:0], 1'b0};
end

always @(shift_reg) begin
    out = shift_reg[7];
end
endmodule