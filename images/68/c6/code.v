module top_module(D,rst,clk,q);input D,rst,clk;
  output q;
  reg q;
  
  always @(posedge clk) begin
    if(rst==1) begin
      q<=0;
    end
    else begin
      q<=D;
    end
  end
endmodule