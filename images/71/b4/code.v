module top_module(
    input clk,
    input rst,
    input in,
    output rise_out,  
    output fall_out);reg in_reg;


always@(posedge clk)begin
   if(rst)begin
      in_reg <= 1'b0;
   end else begin
      in_reg <= in;
   end
end


assign rise_out = ~in_reg & in; 


assign fall_out = in_reg & ~in; 

endmodule