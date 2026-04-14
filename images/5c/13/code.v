module top_module(
    input axi_clk,
    output reg div_clk
    );always @(posedge axi_clk)
    begin
      if (div_clk) begin
        div_clk <= 0;
      end
      else begin
        div_clk <= 1;
      end
    end
endmodule