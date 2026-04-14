module top_module(
input [7:0] addr,
input CLK,
output reg [15:0] data);always@(*) begin
	case(addr)	
        8'h00:data<=16'hF104;
	    8'h01:data<=16'hF100;
	    default:data<=16'h0000;	
	endcase
end

endmodule