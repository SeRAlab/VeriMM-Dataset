module top_module(state, data_count, full, empty, wr_ack, wr_err, rd_ack, rd_err);input [2:0] state; 
input [3:0] data_count; 
output wr_ack, wr_err, rd_ack, rd_err, full, empty; 

parameter INIT = 3'b000; 
parameter NO_OP = 3'b001; 
parameter WRITE = 3'b010; 
parameter READ = 3'b011; 
parameter WR_ERROR = 3'b100; 
parameter RD_ERROR = 3'b101; 

reg wr_ack, wr_err, rd_ack, rd_err, full, empty; 

always @ (data_count) 
begin 
	if(data_count == 4'b0000) {empty, full} = 2'b10; 
	else if(data_count == 4'b1000) {empty, full} = 2'b01; 
	else {empty, full} = 2'b00; 
end

always @ (state) 
begin 
	case(state)
	INIT: {wr_ack, wr_err, rd_ack, rd_err} = 4'b0000; 
	NO_OP: {wr_ack, wr_err, rd_ack, rd_err} = 4'b0000; 
	WRITE: {wr_ack, wr_err, rd_ack, rd_err} = 4'b1000; 
	READ: {wr_ack, wr_err, rd_ack, rd_err} = 4'b0010; 
	WR_ERROR: {wr_ack, wr_err, rd_ack, rd_err} = 4'b0100; 
	RD_ERROR: {wr_ack, wr_err, rd_ack, rd_err} = 4'b0001; 
	default: {wr_ack, wr_err, rd_ack, rd_err} = 4'bx; 
	endcase 
end

endmodule