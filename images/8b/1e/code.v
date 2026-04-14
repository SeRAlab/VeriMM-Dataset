module top_module(
	input rst,
	input ym_p1,
	input [15:0] data,
	output reg sh,
	output so
);reg [12:0] serial_data;
	reg [3:0] cnt;
	
	assign so = serial_data[0];	
	always @(posedge rst or posedge ym_p1) begin
		if( rst ) begin
			sh <= 1'b0;			
			cnt <= 0;
		end
		else begin			
			cnt <= cnt + 1'b1;
			if( cnt==4'd2 ) begin
				casex( data[15:10] )
					6'b1XXXXX: serial_data <= { 3'd7, data[15:6]}; 
					6'b01XXXX: serial_data <= { 3'd6, data[14:5]}; 
					6'b001XXX: serial_data <= { 3'd5, data[13:4]}; 
					6'b0001XX: serial_data <= { 3'd4, data[12:3]}; 
					6'b00001X: serial_data <= { 3'd3, data[11:2]}; 
					6'b000001: serial_data <= { 3'd2, data[10:1]}; 
					default:   serial_data <= { 3'd1, data[ 9:0]}; 
				endcase
			end
			else serial_data <= serial_data>>1;
			if( cnt==4'd10 ) sh<=1'b1;
			if( cnt==4'd15 ) sh<=1'b0;
		end
	end
endmodule