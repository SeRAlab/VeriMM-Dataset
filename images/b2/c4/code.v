module top_module(
  input clk, rst, up_down,
  output reg [3:0] q,
  output reg carry
);always @(posedge clk or posedge rst) begin
    if (rst) begin
      q <= 4'b0;
      carry <= 1'b0;
    end else if (up_down == 1'b0) begin
      // Up counter
      if (q == 4'b1111) begin
        q <= 4'b0;
        carry <= 1'b1;
      end else begin
        q <= q + 4'b1;
        carry <= 1'b0;
      end
    end else begin
      // Down counter
      if (q == 4'b0000) begin
        q <= 4'b1111;
        carry <= 1'b1;
      end else begin
        q <= q - 4'b1;
        carry <= 1'b0;
      end
    end
  end

endmodule