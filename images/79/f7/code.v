module top_module(
    input Overflow,
    input [31:0]DataOut,
    input [31:0]Addr,
    input [4:0]Rw_in,
    input RegWr,
    input MemtoReg,
    input clk,
    output reg [31:0]DataIn,
    output reg WE,
    output reg [4:0]Rw
       );always@(negedge clk)
    begin
     WE<=(~Overflow)&RegWr;
    Rw<=Rw_in;
    if(MemtoReg)
    DataIn<=DataOut;
    else 
    DataIn<=Addr;
    end 
endmodule