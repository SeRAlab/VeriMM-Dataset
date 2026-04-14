module top_module(
out             ,  
enable          ,  
clk             ,  
reset              
);output [7:0] out;

input enable, clk, reset;

reg [7:0] out;
wire        linear_feedback;


assign linear_feedback = !(out[7] ^ out[3]);

always @(posedge clk)
if (reset) begin 
  out <= 8'b0 ;
end else if (enable) begin
  out <= {out[6],out[5],
          out[4],out[3],
          out[2],out[1],
          out[0], linear_feedback};
end 

endmodule