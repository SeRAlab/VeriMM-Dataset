module counter_4bit(
  input clk,
  input rst_n,
  output reg [3:0] count
);

  always @(posedge clk or negedge rst_n) begin
    if (~rst_n)
      count <= 4'b0000; // Initialize to 0
    else begin
      count <= count + 1;
    end
  end

endmodule