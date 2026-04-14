module top_module(_input0, _input1, _input2, display2, display1, display0, displayWrite);input [31:0] _input0, _input1, _input2;
	output reg [6:0] display0, display1, display2;
	input displayWrite;
	always @(posedge displayWrite) begin
		display0 = _input0;
		display1 = _input1;
		display2 = _input2;
	end	
endmodule