module up_down_counter (
  input clk,
  input reset,
  input enable,
  input up_down,
  output reg [3:0] count
);

  always @(posedge clk) begin
    if (reset) begin
      count <= 4'b0000;
    end
    else if (enable) begin
      if (up_down) begin
        count <= count + 1'b1;
      end
      else begin
        count <= count - 1'b1;
      end
    end
  end

endmodule