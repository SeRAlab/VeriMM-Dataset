module top_module(input clk, input rst, input data, output reg [2:0] q);reg [2:0] q1, q2, q3;

  always @(posedge clk or negedge rst) begin
    if (rst == 0) begin
      q1 <= 0;
      q2 <= 0;
      q3 <= 0;
    end
    else begin
      q1 <= data;
      q2 <= q1;
      q3 <= q2;
    end
  end

  assign q = q3;

endmodule