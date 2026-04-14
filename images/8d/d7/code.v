module sync_ram(
    input wire clk,
    input wire we,
    input wire [3:0] addr,
    input wire [7:0] din,
    output reg [7:0] dout
    );

reg [7:0] ram [15:0];

always @(posedge clk) begin
    if (we)
        ram[addr] <= din;
    dout <= ram[addr];
end

endmodule