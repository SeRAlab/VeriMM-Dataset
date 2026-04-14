module counter_3bit (
  input clk,
  input reset,
  input enable,
  output reg[2:0] count
);

  always @(posedge clk) begin
    if (reset) begin
      count <= 3'b0;
    end else if (enable) begin
      if (count == 3'b110) begin
        count <= 3'b0;
      end else begin
        count <= count + 1;
      end
    end
  end

endmodule
