module top_module(
  input clk,
  input reset,
  input inc_dec,
  output reg [2:0] count
);always @(posedge clk or posedge reset) begin
  if (reset) begin
    count <= 0;
  end else begin
    if (inc_dec) begin
      if (count == 7) begin
        count <= 0;
      end else begin
        count <= count + 1;
      end
    end else begin
      if (count == 0) begin
        count <= 7;
      end else begin
        count <= count - 1;
      end
    end
  end
end

endmodule