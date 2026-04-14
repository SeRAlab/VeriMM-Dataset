module top_module(a,b,aluc,result
    );input wire [31:0] a,b;
	input wire [4:0] aluc;
	output reg [31:0] result;
	
	always @*
	begin
		case(aluc)
			5'd0:
			begin
				result=a+b;
			end
			5'd1:
			begin
				result=a-b;
			end
			5'd2:
			begin
				result=a&b;
			end
			5'd3:
			begin
				result=a|b;
			end
			5'd6:
			begin
				result=b<<a;
			end
			5'd10:
			begin
				result=b>>a;
			end
			5'd8:
			begin
				result=(b>>a)|({32{b[31]}}<<(32'd32));
			end
			default:
			begin
				result=0;
			end
		endcase
	end

endmodule