module top_module(
  input aclk,
  input areset,
  output reg [3:0] count,
  output reg overflow
);always @(posedge aclk) begin
    if (areset) begin
      count <= 4'b0000;
      overflow <= 1'b0;
    end
    else begin
      if (count == 4'b1111) begin
        count <= 4'b0000;
        overflow <= 1'b1;
      end
      else begin
        count <= count + 1;
        overflow <= 1'b0;
      end
    end
  end
  
endmodule