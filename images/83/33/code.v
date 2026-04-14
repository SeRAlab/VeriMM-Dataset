module binary_counter(
  input clk,
  input rst_n,
  input up_down,
  output reg [7:0] count
);

  always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
      count <= 8'b0;
    end
    else begin
      if (up_down)
        count <= count + 1;
      else
        count <= count - 1;
    end
  end

endmodule