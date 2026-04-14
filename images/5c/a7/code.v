module top_module(A,B,CI,SUM,CO);parameter width=8'b00100011;

  output [width-1 : 0] SUM;
  output CO;
  input [width-1 : 0] A,B;
  input CI;

  wire [width-1 : 0] SUM;
  reg [width-2 : 0] sum_temp;
  reg CO;
  reg c_out;

	assign SUM = {CO, sum_temp};

always @(A or B or CI)
  begin
    {CO, sum_temp} = A+B+CI;




  end

endmodule