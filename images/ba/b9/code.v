module top_module(
  input [3:0] A,
  input [3:0] B,
  input Cin,
  input AddSub,
  input Clr,
  output reg Cout,
  output reg [3:0] Sum
);always @(*) begin
    case (AddSub)
      0: // Addition
        if (Clr) begin
          Sum <= 0;
          Cout <= 0;
        end
        else begin
          Sum <= A + B + Cin;
          Cout <= (A + B + Cin >= 16);
        end
      1: // Subtraction
        if (Clr) begin
          Sum <= 0;
          Cout <= 0;
        end
        else begin
          Sum <= A - B - ~Cin;
          Cout <= (A - B - ~Cin < 0);
        end
    endcase
  end

endmodule