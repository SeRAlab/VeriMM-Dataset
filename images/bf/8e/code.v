module top_module(addr,q0,q1,q2,q3,q4,q5,q);input wire [2:0] addr;
input wire [15:0] q0,q1,q2,q3,q4,q5;
output reg [15:0] q;

always @ (*)
	begin
		case (addr)
			3'd0:q<=q0;
			3'd1:q<=q1;
			3'd2:q<=q2;
			3'd3:q<=q3;
			3'd4:q<=q4;
			3'd5:q<=q5;
			default:q<=16'd65535;
		endcase 
	end  

endmodule