module top_module(
  output reg [3:0] producer_data  // Changed to reg type for matching declaration
);reg producer_iclk; 
  reg [3:0] i = 4'b0000; 
  
  always @(posedge producer_iclk)  // Use posedge for clock edge sensitivity
  begin 
    producer_data = producer_data + 1; 
  end 
  
  initial 
  begin 
    producer_data = 0; 
    producer_iclk = 0; 
  end 
  
  always 
  begin 
    #5 producer_iclk = ~producer_iclk; 
  end 
endmodule