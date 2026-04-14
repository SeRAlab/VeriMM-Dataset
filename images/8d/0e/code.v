module top_module(
    input clk,
    input reset,
    input a,
    input b,
    output dir,
    output [31:0] count
    );reg [2:0] a_prev;
reg [2:0] b_prev;
reg dir_reg=1'b0;
reg [31:0] count_reg=0;





always @(posedge clk)
 begin
    a_prev <= {a_prev[1:0],a};
    b_prev <= {b_prev[1:0],b};
  end
  
always @(posedge clk or posedge reset)
   begin
    if (reset == 1'b1) begin
       {dir_reg, count_reg} <= {1'b0, 32'b0};
      end
    else
     case ({a_prev[2],b_prev[2],a_prev[1],b_prev[1]})
      4'b0010: {dir_reg,count_reg} <={1'b1,count_reg+32'b1};
      4'b1011: {dir_reg,count_reg} <={1'b1,count_reg+32'b1};
      4'b1101: {dir_reg,count_reg} <={1'b1,count_reg+32'b1};
      4'b0100: {dir_reg,count_reg} <={1'b1,count_reg+32'b1};
      4'b0001: {dir_reg,count_reg} <={1'b0,count_reg-32'b1};
      4'b0111: {dir_reg,count_reg} <={1'b0,count_reg-32'b1};
      4'b1110: {dir_reg,count_reg} <={1'b0,count_reg-32'b1};
      4'b1000: {dir_reg,count_reg} <={1'b0,count_reg-32'b1};
      default: {dir_reg,count_reg} <= {dir_reg,count_reg};
     endcase
   end
     
assign count=count_reg;
assign dir = dir_reg;
     
endmodule