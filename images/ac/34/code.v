module top_module( input clk, input d, output reg q );reg [1:0] stage1, stage2;

  always @(posedge clk) begin
    stage2 <= stage1;
    stage1 <= d;
    q <= stage2[1];
  end

endmodule