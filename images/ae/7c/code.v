module top_module(a,b,aluc,result);input wire [31:0] a,b;
	input wire [4:0] aluc;
	output reg [31:0] result;

	always @*
	begin
		case(aluc)
			5'd0://0:add
				result=a+b;
			5'd1://1:addu
				result=a+b;
			5'd2://2:sub
				result=a-b;
			5'd3://3:subu
				result=a-b;
			5'd4://4:and
				result=a&b;
			5'd5://5:or
				result=a|b;
			5'd6://6:xor
				result=a^b;
			5'd7://7:nor
				result=~(a|b);
			5'd8://8:slt
				result=a<b;
			5'd9://9:sltu
				result=a<b;
			5'd10://10:sll
				result=b<<a;
			5'd11://11:srl
				result=b>>a;
			5'd12://12:sra
			begin
				case(a[4:0])
				5'd0:result=b;
				5'd1:result={b[31],b[31:1]};
				5'd2:result={{2{b[31]}},b[31:2]};
				5'd3:result={{3{b[31]}},b[31:3]};
				5'd4:result={{4{b[31]}},b[31:4]};
				5'd5:result={{5{b[31]}},b[31:5]};
				5'd6:result={{6{b[31]}},b[31:6]};
				5'd7:result={{7{b[31]}},b[31:7]};
				5'd8:result={{8{b[31]}},b[31:8]};
				5'd9:result={{9{b[31]}},b[31:9]};
				5'd10:result={{10{b[31]}},b[31:10]};
				5'd11:result={{11{b[31]}},b[31:11]};
				5'd12:result={{12{b[31]}},b[31:12]};
				5'd13:result={{13{b[31]}},b[31:13]};
				5'd14:result={{14{b[31]}},b[31:14]};
				5'd15:result={{15{b[31]}},b[31:15]};
				5'd16:result={{16{b[31]}},b[31:16]};
				5'd17:result={{17{b[31]}},b[31:17]};
				5'd18:result={{18{b[31]}},b[31:18]};
				5'd19:result={{19{b[31]}},b[31:19]};
				5'd20:result={{20{b[31]}},b[31:20]};
				5'd21:result={{21{b[31]}},b[31:21]};
				5'd22:result={{22{b[31]}},b[31:22]};
				5'd23:result={{23{b[31]}},b[31:23]};
				5'd24:result={{24{b[31]}},b[31:24]};
				5'd25:result={{25{b[31]}},b[31:25]};
				5'd26:result={{26{b[31]}},b[31:26]};
				5'd27:result={{27{b[31]}},b[31:27]};
				5'd28:result={{28{b[31]}},b[31:28]};
				5'd29:result={{29{b[31]}},b[31:29]};
				5'd30:result={{30{b[31]}},b[31:30]};
				5'd31:result={32{b[31]}};
				endcase
			end
			5'd14://14 lui
				result={b[15:0],16'b0};
			default:
			begin
				result=0;
			end
		endcase
	end

endmodule