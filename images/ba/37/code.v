module top_module(
    we,
    addr,
    din,
    dout,
    clk
);input we;
input [9:0] addr;
input [31:0] din;
output reg [31:0] dout;
input clk;

reg [31:0] memory [0:1023]; // 1KB memory with 32-bit wide data

always @(posedge clk) begin
    if (we) begin
        memory[addr] <= din; // Write operation
    end
    dout <= memory[addr]; // Read operation
end

endmodule