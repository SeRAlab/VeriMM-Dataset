module top_module( data0_i, data1_i, data2_i, select_i, data_o );parameter size = 32;			   
			

input wire	[size-1:0] data0_i;          
input wire	[size-1:0] data1_i;
input wire	[size-1:0] data2_i;
input wire	[2-1:0] select_i;

output reg	[size-1:0] data_o; 


always@(data0_i or data1_i or data2_i or select_i)begin
    case(select_i)
        0: data_o = data0_i;
        1: data_o = data1_i;
        2: data_o = data2_i;
        3: data_o = data2_i;
    endcase
end
endmodule