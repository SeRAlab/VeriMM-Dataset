module top_module( Din, Wclk, nRclk, Waddr, Raddr, Dout );input  Wclk;                 
  input  nRclk;                
  
  input  [11:0]Waddr;          
  input  [11:0]Raddr;          
  input  [17:0]Din;            
  
  output [17:0]Dout;           
 
  reg [17:0] Dout;
  reg [17:0] Mem_data [4095:0];

  always @( posedge Wclk ) begin
    Mem_data[Waddr] <= Din;
  end

  always @( negedge nRclk ) begin
    Dout <= Mem_data[Raddr];
  end
  
endmodule