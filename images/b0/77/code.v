module top_module(IN,OUT1,OUT2,INADDRESS,OUT1ADDRESS,OUT2ADDRESS,WRITE,CLK,RESET);input CLK,RESET;         
  
  
  input WRITE;               
  input [7:0] IN;            
  input [2:0] INADDRESS;     

  
  input [2:0] OUT1ADDRESS;   
  output [7:0] OUT1;         

  
  input [2:0] OUT2ADDRESS;   
  output [7:0] OUT2;         
  
  
  reg [7:0] registers[7:0];       

  integer i;    

  always @(RESET)      
  begin
    if(RESET)begin      
      #2;      
      for (i=0; i<8; i=i+1) begin    
        registers[i] = 8'b0;         
      end
    end
  end

  always @(posedge CLK)  
  begin    
    if(WRITE)begin         
      #2;   
      registers[INADDRESS] <= IN;        
    end 
  end

  
  assign #2 OUT1 =  registers[OUT1ADDRESS];    
  assign #2 OUT2 =  registers[OUT2ADDRESS];endmodule