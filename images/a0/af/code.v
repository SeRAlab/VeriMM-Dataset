module top_module(
  out, 
  data, 
  clk 
  
);input data, clk; 


output out;


reg out;


always @ ( posedge clk) begin
  out <= data;
end

endmodule