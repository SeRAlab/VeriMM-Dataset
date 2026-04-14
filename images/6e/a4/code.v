module top_module(
  input [3:0] A,
  input [3:0] B,
  input Cin,
  input mode,
  output reg [3:0] S,
  output reg Cout
);always @(*) begin
    if(mode == 0) begin //addition
      S = A + B + Cin;
      Cout = (S >= 16) ? 1 : 0;
    end
    else begin //subtraction
      S = A - B - Cin;
      Cout = (S < 0) ? 0 : 1;
    end
  end
  
endmodule