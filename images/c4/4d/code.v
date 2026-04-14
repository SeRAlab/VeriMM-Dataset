module counter(clk, rst, count);
  input clk, rst;
  output reg [3:0] count;
  
  always @(posedge clk, posedge rst) begin
    if (rst) begin
      count <= 4'b0;
    end else if (count == 4'b1001) begin
      count <= 4'b0;
    end else begin
      count <= count + 1;
    end
  end
  
endmodule