module top_module(
input wire clk,
input sda,
output reg out
);always@(  posedge sda  )
  begin
    if( clk ==  1)
      begin
        out <= 1'b1;
      end
    else
      begin
        out <= 1'b0;
      end
  end

endmodule