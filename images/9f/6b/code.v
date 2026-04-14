module top_module(
    input clk,
    input [13:0] addr,
    input [1:0] din,
    input we,
    output [1:0] dout
);reg [1:0] ram[0:16383];
reg [1:0] dout_reg;

always @(posedge clk) begin
    if (we) begin
        ram[addr] <= din;
    end
    dout_reg <= ram[addr];
end

assign dout = dout_reg;

endmodule