module top_module(
    input [4:0] line_number,
    output  reg [7:0] line_code
    );parameter [7:0] line00 = 8'h01;
parameter [7:0] line01 = 8'h03;
parameter [7:0] line02 = 8'h07;
parameter [7:0] line03 = 8'h0F;
parameter [7:0] line04 = 8'h1F;
parameter [7:0] line05 = 8'h3F;
parameter [7:0] line06 = 8'h7F;
parameter [7:0] line07 = 8'hFF;
parameter [7:0] line08 = 8'h07;
parameter [7:0] line09 = 8'h03;
parameter [7:0] line10 = 8'h01;

always @(*) begin
	case(line_number)
		4'b0000 : line_code = line00;
		4'b0001 : line_code = line01;
		4'b0010 : line_code = line02;
		4'b0011 : line_code = line03;
		4'b0100 : line_code = line04;
		4'b0101 : line_code = line05;
		4'b0110 : line_code = line06;
		4'b0111 : line_code = line07;
		4'b1000 : line_code = line08;
		4'b1001 : line_code = line09;
		4'b1010 : line_code = line10;
		default : line_code = 1'b0;
	endcase
end
endmodule