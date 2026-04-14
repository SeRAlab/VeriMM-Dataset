module top_module(
    
    input [31:0] Address,
    input MemWrite,ler,
	 input [7:0] WriteData,
    output reg [7:0] ReadData
    );reg [7:0] memory [0:500];

    reg [31:0] addr_reg = 0;
		
	
	
	
	
	

    
    
    always @(*) begin
        if (MemWrite) begin
            memory[Address] <= WriteData;
        end
		  else if(ler) begin
		  addr_reg <= Address;
		 
		 ReadData <= memory[addr_reg];
		  
		  end
    end

    
   
      
   
    
    



endmodule