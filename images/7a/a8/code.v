module top_module(
    input clk,
    input rst,
    input in,
    output one_shot_out);reg in_reg;


always@(posedge clk)begin
   if(rst)begin
      in_reg <= 1'b0;
   end else begin
      in_reg <= in;
   end
end


assign one_shot_out = ~in_reg & in;


endmodule