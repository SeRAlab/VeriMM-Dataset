module top_module(input memread, input [7:0] address, output reg [31:0] readdata);reg [31:0] mem_array [63:0];
  
 
  always@(memread, address, mem_array[address])
  begin
    if(memread)begin
      readdata=mem_array[address];
    end
  end

endmodule