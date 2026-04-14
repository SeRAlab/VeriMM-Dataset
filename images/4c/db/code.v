module top_module(
input                       i_clk,
input                       i_rst,

input       [31:0]          i_a_in,         
input       [31:0]          i_b_in,         
input       [1:0]           i_function,
input                       i_execute,

output      [31:0]          o_out,
output      [1:0]           o_flags,        
output                      o_done    
);wire        enable;
wire        accumulate;

reg  [31:0] product;
reg  [3:0]  count;

assign enable         = i_function[0];
assign accumulate     = i_function[1];

assign o_out   = product;

assign o_flags = {o_out[31], o_out == 32'd0 }; 
assign o_done  = 1'b1;


always @(posedge i_clk or posedge i_rst) begin
  if (i_rst) begin
    product <= 32'b0;
    count <= 4'b0;
  end else if(enable) begin
    count <= count + 1;
    if (i_execute && count == 0) begin
      product <= i_a_in*i_b_in;
    end else if (i_execute && accumulate && count == 3) begin
      product <= product + i_a_in;
    end
  end else begin
    product <= 32'b0;
    count <= 4'b0;
  end
end
























 











  





    











        





























                     
endmodule