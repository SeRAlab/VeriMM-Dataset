module top_module(Clk, Reset, MEM_READ, MEM_WRITE, DataAddress, WriteData, ReadData);input              Clk,
                     Reset,
                     MEM_READ,
                     MEM_WRITE;
  input [7:0]        DataAddress,   
                     WriteData;		   
  output reg[7:0]    ReadData;
  reg [7:0] Core[256-1:0];			    
  integer i;


  
  always@*                    
  begin
    if (MEM_READ) ReadData <= Core[DataAddress];    
    else  ReadData <= 'bz;                         
  end
  
  
  always @ (posedge Clk)		 
	begin
    if(Reset) begin
      
      for(i=0;i<256;i = i + 1)
        Core[i] <= 0;   
	  end
    else if(MEM_WRITE) begin
      Core[DataAddress] <= WriteData;
    end
	end
endmodule