module top_module(
   input wire clk,
   input wire [27:0] addr,
   input wire [255:0] data,
   input wire wen
);reg [(1<<28)-1:0][255:0] mem;
   always @(posedge clk) begin
      if (wen) mem[addr] <= data;
   end
endmodule