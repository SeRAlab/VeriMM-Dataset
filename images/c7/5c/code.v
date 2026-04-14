module button_counter (
  input clk,
  input button,
  output reg [2:0] count
);

  always @(posedge clk) begin
    if (button && count < 5) begin
      count <= count + 1;
    end else if (count == 5) begin
      count <= 0;
    end
  end

endmodule