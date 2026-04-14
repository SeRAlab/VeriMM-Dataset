module up_counter(
  input clk,
  input rst_n,
  output reg [3:0] count
);

  always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
      count <= 4'b0000;
    end
    else if (count == 4'b1111) begin
      count <= 4'b0000;
    end
    else begin
      count <= count + 1;
    end
  end

endmodule