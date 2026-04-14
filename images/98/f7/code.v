module top_module(
   input [15:0] in1,
    input [15:0] in2,
	 input [15:0] in3,
    input [15:0] in4,
    input [1:0] control,
    input clock,
    output reg [15:0] out
    );always @ (in1 or in2 or in3 or in4 or control)

begin
	
	case(control)
		0:out = in1;
		1:out = in2;
		2:out = in3;
		3:out = in4;
	endcase
end

endmodule