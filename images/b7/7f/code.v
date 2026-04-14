module up_down_counter (
  input clk,
  input en,
  input up_down,
  output reg [3:0] count
);

  always @(posedge clk) begin
    if (en) begin
      if (up_down)
        count <= count + 1;
      else
        count <= count - 1;
    end
  end

endmodule