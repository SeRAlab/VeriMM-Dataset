module binary_counter(
  input clk,
  input reset_n,
  output reg [3:0] count
);

  always @(posedge clk or negedge reset_n) begin
    if (~reset_n) begin
      count <= 0;
    end else begin
      count <= count + 1;
    end
  end

endmodule