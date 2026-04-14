module top_module(
    input [7:0]A,
    input [7:0]B,
    output [7:0] Sum,
    output Overflow
    );reg[8:0] tempSum;
	reg tempOv;

	always @(A or B)
	  begin
		 tempSum = A + B;
		 tempOv = tempSum[8];
	  end

  assign Sum = tempSum;
  assign Overflow = tempOv;




endmodule