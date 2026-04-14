module top_module(clk, mdor_we, mdor_next, mdor);input clk;
    input mdor_we;
    input [31:0] mdor_next;
    output reg [31:0] mdor;

  always @(posedge clk) begin
    if (mdor_we == 1) begin
      mdor <= mdor_next;
    end
  end

endmodule