module top_module(data0, data1, data2, data3, data4, data5, op, shop, out);output reg [15:0] out;
input [15:0] data0, data1, data2, data3, data4, data5;
input [1:0] op;
input [1:0]shop;


always@(*) begin
	case(op)
		0: out = data0;
		1: out = data1;
		2: out = data2;
		default:
			case(shop)
				0: out = data3;
				1: out = data4;
				3: out = data5;
				default: out = data5;
			endcase
	endcase
end

endmodule