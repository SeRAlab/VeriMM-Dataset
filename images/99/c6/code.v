module top_module(
input  [31:0] data_in, 
input          clk, clk_en,    
input          reset,start,  
input          sync,    
output [31:0] data_out 
);reg [31:0] Q;




always @(posedge clk) 
begin
 if(reset)
  Q <= 32'h00000000; 
 else 
 if(clk_en)
 begin
 if(start)
 begin
 if(sync)
  Q <= data_in; 
  end
 end
end 

assign data_out = Q;

endmodule