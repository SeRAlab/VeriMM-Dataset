module top_module(
    input [31:0] MFRTMout,
    input [31:0] address,
    input [1:0] sel,
    output reg [31:0] Wdata
    );wire [1:0]lo=address[1:0];
	always @(*)begin
		case(sel)
			2'b00: Wdata<=MFRTMout;
			2'b01: begin
				if (lo==0)
					Wdata<={16'h0000,MFRTMout[15:0]};
				else if (lo==2)
					Wdata<={MFRTMout[15:0],16'h0000};
				else
					Wdata<=0;
				end
			2'b10: begin
				if (lo==0)
					Wdata<={24'h000000,MFRTMout[7:0]};
				else if (lo==1)
					Wdata<={16'h0000,MFRTMout[7:0],8'h00};
				else if (lo==2)
					Wdata<={8'h00,MFRTMout[7:0],16'h0000};
				else if (lo==3)
					Wdata<={MFRTMout[7:0],24'h000000};
				else
					Wdata<=0;
				end
		endcase
	end
endmodule