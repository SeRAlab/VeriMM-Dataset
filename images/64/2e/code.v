module top_module(
input wire [31:0]   reg_data,
input wire [31:0]   ex_mem_data,
input wire [31:0]   mem_wb_data,
input wire [1:0]    sel,
output wire [31:0]  out
    );assign out = OUT(reg_data, ex_mem_data, mem_wb_data, sel);
    
    function [31:0] OUT;
    input [31:0]    a;
    input [31:0]    b;
    input [31:0]    c;
    input [1:0]     sel;
    begin
        case( sel )
        2'b00: OUT = a;
        2'b10: OUT = b;
        2'b01: OUT = c;
        default: OUT = a;
        endcase
    end
    endfunction
    
endmodule