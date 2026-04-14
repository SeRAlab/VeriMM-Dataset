module counter(
  input clk,
  input rst_n,
  input up,
  output reg [3:0] count
);

  always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
      count <= 4'b0000;
    end
    else begin
      if (up) begin
        if (count == 4'b1111)
          count <= 4'b0000;
        else
          count <= count + 1;
      end
      else begin
        if (count == 4'b0000)
          count <= 4'b1111;
        else
          count <= count - 1;
      end
    end
  end

endmodule