module sync_ram(
    input clk,
    input we,
    input [3:0] addr,
    input [15:0] data_in,
    output reg [15:0] data_out
);

reg [15:0] memory [0:15];

always@(posedge clk)
begin
  if(we)
    memory[addr] <= data_in;
  data_out <= memory[addr];
end

endmodule