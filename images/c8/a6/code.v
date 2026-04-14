module counter(clk, rst, en, count);
  input clk, rst, en;
  output reg [1:0] count;

  always @(posedge clk) begin
    if (rst) begin
      count <= 2'b0;
    end else if (en) begin
      count <= count + 2'b1;
    end
  end

endmodule