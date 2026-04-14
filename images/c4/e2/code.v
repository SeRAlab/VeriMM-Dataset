module binary_counter(clk, reset, count, overflow);
  input clk, reset;
  output reg [3:0] count;
  output reg overflow;
  
  always @(posedge clk) begin
    if (reset) begin
      count <= 4'b0000;
      overflow <= 1'b0;
    end
    else if (count == 4'b1111) begin
      count <= 4'b0000;
      overflow <= 1'b1;
    end
    else begin
      count <= count + 1;
      overflow <= 1'b0;
    end
  end
endmodule