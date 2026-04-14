module top_module(
	input [7:0] dataIn,
	output [7:0] dataOut
);reg [7:0] data;
  always @ (dataIn) begin     
    case(dataIn)
      8'h1D    : data = 8'd87;     
      8'h1B    : data = 8'd83;
		8'h1C    : data = 8'd65;
		8'h23    : data = 8'd68;
      default  : data = 0;     
    endcase
  end
  
  assign dataOut = data;

endmodule