module up_counter (
  input clk,
  input reset,
  output reg [3:0] count
);

always @(posedge clk) begin
  if (reset) begin
    count <= 4'b0000;
  end else begin
    if (count == 4'b1111) begin
      count <= 4'b0000;
    end else begin
      count <= count + 1;
    end
  end
end

endmodule
