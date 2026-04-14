module top_module(input clk,
              input         rst,
              
              output [31:0] data_a,
              input [31:0]  addr_a,
              
              output [31:0] data_b,
              output        strobe_b,
              input [31:0]  addr_b,
              input [31:0]  data_b_in,
              input [31:0]  data_b_we);parameter RAM_DEPTH = 16384;
   
   reg [31:0]                   mem [0:RAM_DEPTH-1];
   
   assign data_a = mem[addr_a];
   assign data_b = mem[addr_b];
   assign strobe_b = (addr_b[31:16] == 0);

   always @(posedge clk)
     begin
        if (data_b_we & (addr_b[31:16] == 0)) begin
           mem[addr_b] <= data_b_in;
        end
     end

endmodule