module top_module( clk, w_en, write_address, w_data, read_address, r_data);input clk; 
  input w_en; 
  input [4:0] write_address;  
  input [7:0] w_data;        
  input [4:0] read_address;   

  output[7:0] r_data; 
  reg   [7:0] r_data;

  reg [4:0]  read_address_reg;   
  reg [7:0]  mem [31:0];
   
  always @ (posedge clk) begin     
    if (w_en) begin        
      mem[write_address] <= w_data;
    end	 
  end 
   
  always @ (posedge clk) begin      
    r_data <= mem[read_address_reg];      
    read_address_reg <= read_address;   
  end 

endmodule