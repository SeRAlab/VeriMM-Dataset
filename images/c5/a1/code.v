module up_counter_4bit
   (count,
    clk,
    reset);
  output reg [3:0] count;
  input clk, reset;

  always @(posedge clk) begin
    if (reset) begin
      count <= 4'b0;
    end else begin
      count <= count + 1;
    end
  end

endmodule