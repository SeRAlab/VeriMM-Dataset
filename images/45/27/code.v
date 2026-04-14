module top_module(
    input [3:0] destReg,
    output reg [15:0] decOut
    );always @ (destReg)
		begin
			decOut = 0;
			case (destReg)
				4'h0 : decOut = 16'h0001;
				4'h1 : decOut = 16'h0002;
				4'h2 : decOut = 16'h0004;
				4'h3 : decOut = 16'h0008;
				4'h4 : decOut = 16'h0010;
				4'h5 : decOut = 16'h0020;
				4'h6 : decOut = 16'h0040;
				4'h7 : decOut = 16'h0080;
				4'h8 : decOut = 16'h0100;
				4'h9 : decOut = 16'h0200;
				4'hA : decOut = 16'h0400;
				4'hB : decOut = 16'h0800;
				4'hC : decOut = 16'h1000;
				4'hD : decOut = 16'h2000;
				4'hE : decOut = 16'h4000;
				4'hF : decOut = 16'h8000;
			endcase
		end

endmodule