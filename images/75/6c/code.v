module top_module(
out        ,  
enable     ,  
clk        ,  
reset         
);output [7:0] out;


input enable, clk, reset;


reg [7:0] out;  


always @ (posedge clk)
if (reset) begin
  out <= 8'b0000_0001 ;
end else if (enable) begin
  out <= {out[6],out[5],out[4],out[3],
          out[2],out[1],out[0],out[7]};
end

endmodule