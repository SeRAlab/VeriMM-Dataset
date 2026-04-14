module top_module();reg [3:0] counter;
wire clk,reset,enable, up_en, down_en;

always @ (posedge clk)

if (reset == 1'b0) begin
   counter <= 4'b0000; 
end else begin
  
  if (enable == 1'b1 && up_en == 1'b1) begin
    counter <= counter + 1'b1;
  end
  
  if (enable == 1'b1 && down_en == 1'b1) begin
    counter <= counter - 1'b1;
  end 
end  

endmodule