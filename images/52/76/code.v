module top_module(clock,ram_enable, write_enable,address, data_input, data_output);parameter N=16;
parameter M=12;
input clock,ram_enable,write_enable;
input [M-1:0] address;
input [N-1:0] data_input;
output [N-1:0] data_output;
reg [N-1:0] data_output;
reg [N-1:0] memory [(2**M)-1:0];


always @(posedge clock)
      if (ram_enable)
         if (write_enable) begin
            memory[address] <= data_input;
         end
         else
            data_output <= memory[address];endmodule