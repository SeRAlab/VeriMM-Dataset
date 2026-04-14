module top_module(T,rst,clk,q);input T,rst,clk;
  output q;
  reg q;
  
  always @(posedge clk) begin
    if(rst==1) begin
      q<=0;
    end
    else begin
      q<=~T;
    end
  end
endmodule