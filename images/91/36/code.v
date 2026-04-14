module top_module(input clk,
              input rst,
              input [31:0] addr_a,
              input [31:0] addr_b,
              input [31:0] data_b_in,
              input [31:0] data_b_we,
              output reg [31:0] data_a,
              output reg [31:0] data_b,
              output reg strobe_b);parameter RAM_DEPTH = 1024;
   parameter INIT_FILE = "";
   
   reg [31:0] mem [0:RAM_DEPTH-1];
   
   initial begin
      if (INIT_FILE != "")
         $readmemh(INIT_FILE, mem);
   end
   
   always @(posedge clk) begin
      if (rst) begin
         data_a <= 0;
         data_b <= 0;
         strobe_b <= 0;
      end
      else begin
         if (data_b_we & (addr_b[31:16] == 0)) begin
            mem[addr_b] <= data_b_in;
         end
         data_a <= mem[addr_a];
         data_b <= mem[addr_b];
         strobe_b <= (addr_b[31:16] == 0) ? data_b_we : 0;
      end
   end
   
endmodule