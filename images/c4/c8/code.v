module binary_counter (
  input clk,
  input rst,
  output reg [3:0] count,
  output reg max_reached
);

  always @(posedge clk or posedge rst) begin
    if (rst) begin
      count <= 4'b0;
      max_reached <= 1'b0;
    end
    else if (count == 4'b1111) begin
      count <= 4'b0;
      max_reached <= 1'b1;
    end
    else begin
      count <= count + 1;
      max_reached <= 1'b0;
    end
  end

endmodule