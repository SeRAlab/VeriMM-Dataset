module top_module(
input [7:0]mem_addr,write_data_M,
input clk,reset,write_en,read_en,
input [2:0]opcode,
output reg [7:0]read_data
);reg [7:0]array[63:0];
integer a;
always@ (posedge clk or posedge reset) 
begin
	if(reset) begin
		for(a=0; a<64; a=a+1)
			array[a]<=8'b0;

	array[1] <= 8'hed;

			end
	else if(write_en)begin
		case(opcode)
		3'b001: array[mem_addr]<= write_data_M;	  
		default: array[mem_addr]<= 8'b0;
		endcase	
				end		
end
always @*
	begin
	if(read_en)begin
		case(opcode)
		3'b000: read_data <= array[mem_addr];	
		default: read_data <= 8'b0;
		endcase			
			end
	end
endmodule