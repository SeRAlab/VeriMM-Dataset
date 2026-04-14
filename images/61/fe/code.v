module top_module(
data  ,
clk    ,
reset ,
q     
);input data, clk, reset ; 
output q;
(*ASYNC_REG = "TRUE" *) reg q;
always @ ( posedge clk or posedge reset) begin
  if (reset) begin
    q <= 1'b1;
  end  else begin
    q <= data;
  end
end
endmodule