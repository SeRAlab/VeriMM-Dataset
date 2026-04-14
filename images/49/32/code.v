module top_module(m3,alu_out,shift_out,pc_p1,mem_frwd_data);input [1:0] m3;
input [15:0] alu_out,shift_out,pc_p1;
output reg [15:0] mem_frwd_data;

always @(*)
begin

case(m3)

2'b00:
mem_frwd_data = 16'bx; 

2'b01:
mem_frwd_data = alu_out;

2'b10:
mem_frwd_data = shift_out;

2'b11:
mem_frwd_data = pc_p1;

default:
mem_frwd_data = 16'bx;

endcase

end

endmodule