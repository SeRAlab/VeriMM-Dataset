module top_module(CCLK,rst,instr,IF
    );input CCLK,rst;
	input [31:0] instr;
	output reg [7:0] IF;
	always @(*)
	begin
	if (rst)
		IF=8'd0;
	else
		case(instr[31:26])
		6'b000000:
		begin 
			case(instr[5:0])
			6'b100000:
			begin
				IF=(|instr[15:11])?8'd1:8'h0;
			end
			6'b100001:IF=8'd2;
			6'b100010:IF=8'd3;
			6'b100011:IF=8'd4;
			6'b100100:IF=8'd5;
			6'b100101:IF=8'd6;
			6'b100110:IF=8'd7;
			6'b100111:IF=8'd8;
			6'b101010:IF=8'd9;
			6'b101011:IF=8'd10;
			6'b000000:IF=8'd11;
			6'b000010:IF=8'd12;
			6'b000011:IF=8'd13;
			6'b000100:IF=8'd14;
			6'b000110:IF=8'd15;
			6'b000111:IF=8'd16;
			6'b001000:IF=8'd17;
			endcase
		end
		6'b001000:IF=8'd18;
		6'b001001:IF=8'd19;
		6'b001100:IF=8'd20;
		6'b001101:IF=8'd20;
		6'b001110:IF=8'd22;
		6'b001111:IF=8'd23;
		6'b100011:IF=8'd24;
		6'b101011:IF=8'd25;
		6'b000100:IF=8'd26;
		6'b000101:IF=8'd27;
		6'b001010:IF=8'd28;
		6'b001011:IF=8'd29;
		6'b000010:IF=8'd30;
		6'b000011:IF=8'd31;
		default:IF=8'd0;
		endcase
	end
endmodule