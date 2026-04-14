module top_module(
    input clk,
    input we,
    input [7:0] addr,
    input [17:0] din,
    output reg [17:0] dout
);reg [17:0] ram [255:0];

always @(posedge clk) begin
    if (we) begin
        ram[addr] <= din;
    end
    dout <= ram[addr];
end

endmodule