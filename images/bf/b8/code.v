module SQM_CLK_DIVIDER(   
  clk, 
  reset_n,
  period,
	div
);
parameter bw=12;
input clk; 
input reset_n;
input [bw-1:0]period;
output div;
reg [bw-1:0]count;
reg clkdiv;
initial clkdiv=0;
assign div = period==1 ? clk : clkdiv;
always @(posedge clk or negedge reset_n) begin
  if( !reset_n) begin
    count<=0;
    clkdiv<=0;
  end
  else begin
    if( period==0 ) begin
      clkdiv<=0;
      count<=0;
    end
    else if( count >= period ) begin
        count <= 0;
        clkdiv <= ~clkdiv;
      end
      else count <= count+1;
  end
end
endmodule