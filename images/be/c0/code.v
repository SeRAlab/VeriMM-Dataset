module binary_counter(
  input clk,
  input rst,
  output reg [3:0] count
);

  always @(posedge clk or posedge rst) begin
    if (rst) begin
      count <= 4'b0000;
    end
    else begin
      if (count == 4'b1111)
        count <= 4'b0000;
      else
        count <= count + 1;
    end
  end

endmodule