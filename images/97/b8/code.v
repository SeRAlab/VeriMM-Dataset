module up_down_counter
(
  input clk,
  input reset,
  input load,
  input up_down,
  input [3:0] count_in,
  output reg [3:0] count
);

  always @(posedge clk or posedge reset) begin
    if (reset) begin
      count <= 4'b0;
    end
    else if (load) begin
      count <= count_in;
    end
    else if (up_down) begin
      count <= count + 1;
    end
    else begin
      count <= count - 1;
    end
  end

endmodule