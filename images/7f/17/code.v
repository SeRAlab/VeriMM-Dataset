module top_module(addr, clk, din, dout, we);input              clk, we;
input       [9:0]  addr;
input      [31:0]  din;
output reg [31:0]  dout;

reg        [31:0]  mem [0:1023];


always @(posedge clk) begin
   if(!we) begin
      
      mem[addr] <= din[31:0];
      dout      <= 32'bz;
   end 
   else if(we)
         
	     dout <= mem[addr];
   else 
      dout <= 32'bz;
end


endmodule