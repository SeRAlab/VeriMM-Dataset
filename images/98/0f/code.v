module top_module(addr,be,din,we,clk,dout);input [11:2] addr;
  input [3:0] be; 
  input [31:0] din; 
  input we;         
  input clk;    
  output [31:0] dout;
  
  reg [31:0] dm[1023:0];
   
  assign dout=dm[addr];
   
  always@(posedge clk)
  begin
    if(we)
    begin
      case(be)
        4'b1111:dm[addr][31:0]<=din[31:0];
        4'b0011:dm[addr][15:0]<=din[15:0];
        4'b1100:dm[addr][31:16]<=din[15:0];
        4'b0001:dm[addr][7:0]<=din[7:0];
        4'b0010:dm[addr][15:8]<=din[7:0];
        4'b0100:dm[addr][23:16]<=din[7:0];
        4'b1000:dm[addr][31:24]<=din[7:0];
      endcase
    end
  end
  
  
endmodule