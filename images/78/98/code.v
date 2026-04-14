module top_module(
   
	input wire clk,rst,
	input [7:0] in3,in2,in1,in0,
	output reg [3:0] anodo,
	output reg [7:0] catodo
    );localparam N = 18;
	reg [N-1:0] q_reg;
	wire [N-1:0] q_next;
	
	always @(posedge clk, posedge rst)
	   if (rst)
	    q_reg  <= 0;
	   else 
	    q_reg <= q_next;
	assign q_next = q_reg + 1;
		
	always @(*)
	case (q_reg[N-1:N-2])
	   2'b00: 
		   begin
			  anodo <= 4'b1110;
			  catodo <= in0;
			end 
	   2'b01: 
		   begin
			  anodo <= 4'b1101;
			  catodo <= in1;
			end 
		2'b10: 
		   begin
			  anodo <= 4'b1011;
			  catodo <= in2;
			end 
		default: 
		   begin
			  anodo <= 4'b0111;
			  catodo <= in3;
			end 
	endcase



endmodule