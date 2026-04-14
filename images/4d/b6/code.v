module up_down_counter (
  input clk,
  input reset,
  input en,
  input dir,
  output reg [3:0] count
);

  always @(posedge clk) begin
    if (reset)
      count <= 4'b0000;
    else if (en) begin
      if (dir)
        count <= count + 1;
      else
        count <= count - 1;
    end
  end

endmodule