module counter (
  input clk, rst, enable,
  output reg [7:0] count
);

  always @(posedge clk) begin
    if (rst) begin
      count <= 8'd0;
    end else if (enable) begin
      count <= count + 1;
    end
  end

endmodule