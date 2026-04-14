module top_module(A, B, SUB, SUM);input [3:0] A, B;
  input SUB;
  output reg [3:0] SUM;  // Change output to reg type
  
  reg [3:0] temp;
  
  always @(*) begin
    if(SUB == 0) begin
      temp = A + B;
      SUM = temp;
    end
    else begin
      temp = A - B;
      SUM = temp;
    end
  end
endmodule