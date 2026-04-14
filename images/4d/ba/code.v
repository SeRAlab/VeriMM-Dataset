module top_module(
    input clk,
    input [126:0] in,
    output reg [6:0] out
);reg [3:0] shift_reg;
reg [6:0] count;

always @(posedge clk) begin
    shift_reg <= {shift_reg[2:0], in[126]};
end

always @(posedge clk) begin
    count <= {count[5:0], ~shift_reg[0]};
end

assign out = shift_reg;

endmodule