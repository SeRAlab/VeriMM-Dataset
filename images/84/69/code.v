module top_module(
    input clk,       // Added clk input
    input [0:0] in,
    output reg [2:0] out
);reg [2:0] shift_reg;

always @(posedge clk) begin
    shift_reg <= {shift_reg[1:0], in};
end

assign out = shift_reg;

endmodule