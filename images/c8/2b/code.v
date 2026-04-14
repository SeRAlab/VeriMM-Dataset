module up_counter_4bit(
  input clk,
  input rst,
  output reg [3:0] count
);

  always @(posedge clk) begin
    if (rst) begin
      count <= 4'b0;
    end
    else begin
      count <= count + 1;
    end
  end

endmodule