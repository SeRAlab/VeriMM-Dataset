module top_module(clk , reset , A , RD , WD , WE);input clk,    
        reset,  
        WE;     
  
  input [31:0] A;  
  input [31:0] WD; 
  
  output [31:0] RD; 
  
  reg [31:0] RD = 32'h00000000;
  reg [31:0] memory [0:4];  
  
  wire [4:0] WEline; 
  integer i;
  
  assign WEline = (WE << A); 
  
  
  always@ (posedge clk or negedge reset)
  begin
    if (!reset) 
        for (i=0 ; i < 5 ; i=i+1)
            memory [i] = 32'h00000000;
    else 
      for (i=0 ; i < 5 ; i=i+1)
          if (WEline [i])  memory [i] = WD;
  end
  
  
  always@ (*)
  begin
    if (!reset) RD = 32'h00000000;
    else if (!WE)
      if (A < 5)
        RD = memory [A]; 
      else
        RD = 32'h00000000;
    else
       RD = 32'h00000000;

    
  end
  
endmodule