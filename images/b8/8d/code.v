module top_module(
  input x,
  input y,
  input z,
  output reg out1,
  output reg out2
);always @(*) begin
    if (x & y | !z) begin
      out1 = 1;
    end
    else begin
      out1 = 0;
    end
    
    if (!x & y | z) begin
      out2 = 1;
    end
    else begin
      out2 = 0;
    end
  end
  
endmodule