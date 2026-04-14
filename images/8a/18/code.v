module top_module(
  input rst, clk, enable,
  input [31:0] inc_value,
  output reg [31:0] count
);always @(posedge clk or negedge rst) begin
    if (!rst) begin
      count <= 0;
    end else if (enable) begin
      count <= count + inc_value;
      if (count >= 2**32 - inc_value) begin
        count <= 0;
      end
    end
  end
  
endmodule