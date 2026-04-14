module top_module(
	input clk,
	input reset,
	
	input req, 
	input slave_in, 
	input c, 
	
	
	
	input ack_in, 
	input req_sent,  
	input data_read, 
	output reg [1:0] req_stat, 
	output reg slave_out
    );localparam WAIT 	= 2'd 1 ; 
localparam W_ACK	= 2'd 2 ; 
localparam W_DATA	= 2'd 3 ; 
localparam NO_REQ	= 2'd 0 ; 


reg cmd;

always @(posedge clk or negedge reset) 

if (~reset) 
begin
	req_stat <= NO_REQ;
	slave_out <= 0; 
	cmd <= 0; 
end
else 
begin
	case (req_stat)
	NO_REQ : 	if (req)
				begin
				req_stat <= WAIT;
				slave_out <= 0; 
				cmd <= 0; 
				end 
	WAIT :		begin
				if (req_sent) req_stat <= W_ACK ;
				slave_out <= slave_in;
				end
	W_ACK :		if (ack_in)
				case (cmd)
				1'b0 : req_stat <= W_DATA ; 
				1'b1 : req_stat <= NO_REQ ; 
				default: req_stat <= NO_REQ ;
				endcase
	
	W_DATA :	if (data_read) req_stat <= NO_REQ;
	
	endcase
	
end 



endmodule