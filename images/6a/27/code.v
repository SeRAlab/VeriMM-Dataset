module top_module(
						input wire [31:0] D,
						input wire [1:0] ALU,
						input wire DT,Sign,
						output reg [31:0] ND
						);reg [7:0] Byte;	
reg [31:0] Word;

always @(*)
	begin
		
		case(ALU)								
			2'b00: 	Byte <= D [7:0];		
			2'b01: 	Byte <= D [15:8];
			2'b10: 	Byte <= D [23:16];
			2'b11: 	Byte <= D [31:24];
			default:	Byte <= 8'b0;
		endcase
		
		case(Sign)
			1'b0:		Word <= {{24{Byte[7]}},Byte};
			1'b1:		Word <= {{24'b0},Byte};
			default:	Word <= 32'b0;
		endcase
		
		case(DT)
			1'b0:		ND <= Word;
			1'b1:		ND <= D;
			default:	ND <= 32'b0;
		endcase
	end
endmodule