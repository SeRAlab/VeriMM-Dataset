module top_module(in,out);input [7:0] in;
output reg [15:0] out;
always @ ( in )
  begin
  casez(in)
      8'b0000zzzz: out = 16'b0000000000000001;   
      8'b0001zzzz: out = 16'b0000000000000010;   
      8'b0010zzzz: out = 16'b0000000000000100;   
      8'b0011zzzz: out = 16'b0000000000001000;   
      8'b0100zzzz: out = 16'b0000000000010000;   
      8'b0101zzzz: out = 16'b0000000000100000;   
      8'b0110zzzz: out = 16'b0000000001000000;   
      8'b0111zzzz: out = 16'b0000000010000000;   
      8'b1000zzzz: out = 16'b0000000100000000;   
      8'b1001zzzz: out = 16'b0000001000000000;   
      8'b1010zzzz: out = 16'b0000010000000000;
      8'b1011zzzz: out = 16'b0000100000000000;   
      8'b1100zzzz: out = 16'b0001000000000000;   
      8'b1101zzzz: out = 16'b0010000000000000;     
      8'b1110zzzz: out = 16'b0100000000000000;   
      8'b1111zzzz: out = 16'b1000000000000000;   
  endcase
  end
endmodule