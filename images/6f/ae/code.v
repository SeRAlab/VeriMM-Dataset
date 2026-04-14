module top_module(





clock, reset,



nop,


mem_content,




cal_result,   


rd,

we, wren,



address_dmem,



out_wren,

out_nop,
out_rd,
out_we,

value,

lw


);output [31:0] value;

input lw;

input clock, reset;



input nop;



input [4:0] rd;


input[31:0] cal_result, mem_content;
input we, wren;





output [11:0] address_dmem;



output out_wren;

output out_nop;  assign out_nop = nop;

output out_rd; assign out_rd = rd;

output out_we; assign out_we = we;





assign address_dmem = cal_result[11:0];







assign out_wren = wren & (~nop);













assign value = lw? mem_content: cal_result;



endmodule