module top_module(
    input clk,
    input parallel_load,
    input [3:0] in,
    output reg out
);reg [3:0] shift_reg;

always @(posedge clk) begin
    if (parallel_load) begin
        shift_reg <= in;
    end else begin
        shift_reg <= {shift_reg[2:0], shift_reg[3]};
    end
end

assign out = shift_reg[0];

endmodule