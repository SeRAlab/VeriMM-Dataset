module top_module(
    input [7:0] pc,
    output reg [5:0] text_mem_addr
    );always@(*)	
 text_mem_addr = pc [7:2];
endmodule