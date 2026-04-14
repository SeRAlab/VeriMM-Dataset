module memory_16x4 (dout, din, addr, clk, we);
   input [3:0] addr;
   input [3:0] din;
   input clk, we;
   output [3:0] dout;
   
   reg [3:0] mem [15:0];
   reg [3:0] dout;
   
   always @(posedge clk) begin
      if (we)
         mem[addr] <= din;
   end
   
   always @(*) begin
      dout = mem[addr];
   end
   
endmodule