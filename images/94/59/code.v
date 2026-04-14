module counter_4bit_async_reset(
  input clk,
  input rst,
  output reg [3:0] count
);

  always @(posedge clk or negedge rst) begin
    if (!rst) begin
      count <= 4'b0000;
    end
    else begin
      count <= count + 1;
    end
  end

endmodule