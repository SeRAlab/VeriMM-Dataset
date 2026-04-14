module top_module(a, b, y);input [7:0] a;
  input [7:0] b;
  output reg y; // Change output declaration to 'reg'
  
  always @(*) begin
    if (a >= b) begin
      y = 1;
    end else begin
      y = 0;
    end
  end
endmodule