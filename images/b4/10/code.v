module top_module(
  input signed [7:0] A, B,
  input [1:0] op_code,
  input reset, clk, Cin,
  output reg Cout,
  output reg signed [7:0] out);reg C;

  always @(posedge clk)
  begin
    if (reset) {C,out}<=9'd0;
    else
        case(op_code)
          0: {C,out}<={1'b0,A}+(Cin?{1'b0,~B}:{1'b0,B})+$signed({7'b0,Cin});
          1: out<=A^B;
          2: {C,out}<={1'b0,A}-9'd1;
        endcase
    if (op_code==0 || op_code==2) Cout<=C;
    else Cout<=0;
  end
  
endmodule