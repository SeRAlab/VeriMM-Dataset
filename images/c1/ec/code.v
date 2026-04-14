module up_down_counter (
  input clk,
  input reset,
  input enable,
  output reg [2:0] count
);

  always @(posedge clk, negedge reset) begin
    if (reset == 0) begin
      count <= 3'b0;
    end else if (enable == 1) begin
      count <= count + 1;
    end else begin
      count <= count - 1;
    end
  end

endmodule
