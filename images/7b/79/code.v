module rom_128x4 (
    input clk,
    input [6:0] addr,
    output reg [3:0] read_data );

reg [3:0] memory [127:0];

always @(posedge clk) begin
    read_data <= memory[addr];
end

endmodule