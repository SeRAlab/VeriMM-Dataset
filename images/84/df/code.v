module top_module(input [7:0] pgmaddr, output [7:0] pgmdata);reg [7:0] pmemory[255:0]; 
  assign pgmdata=pmemory[pgmaddr]; 
  initial 
  begin 
  pmemory[0]=8'h82; 
  pmemory[1]=8'hff; 
  pmemory[2]=8'hb8; 
  pmemory[3]=8'hb1; 
  pmemory[4]=8'h83; 
  pmemory[5]=8'h00; 
  pmemory[6]=8'hb2; 
  pmemory[7]=8'h93; 
  pmemory[8]=8'ha1; 
  pmemory[9]=8'h00; 
  end 
 endmodule