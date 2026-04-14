module top_module(
    input clk,
    input en,
    input we,
    input [15:0] addr,
    input [7:0] din,
    output reg [7:0] dout
);reg [15:0] addr_reg;
reg [7:0] memory [0:65535];  // Assuming 64K of 8-bit memory

always @(posedge clk) begin
    if (en) begin
        addr_reg <= addr;  // Update address register
        if (we) begin
            memory[addr] <= din;  // Write data into memory
        end
        dout <= memory[addr];     // Read data from memory
    end
end

endmodule