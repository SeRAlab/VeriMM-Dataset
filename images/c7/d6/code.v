module counter (
  input clk,
  input rst_n,
  input en,
  output reg [3:0] out
);

  always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
      out <= 4'b0;
    end else if (en) begin
      out <= out + 1;
    end
  end

endmodule