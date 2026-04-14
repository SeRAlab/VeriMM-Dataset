module top_module(
    input MEM2REG_M,
    input REGWR_M,
    input [4:0]reg2wr,
    input [31:0]memdata,
    input [31:0]aludata,

    output [4:0]rw,
    output reg [31:0]din,
    output we
);assign we=REGWR_M;
assign rw=reg2wr;
always @(*) begin
     if(MEM2REG_M==1) din<=memdata;
        else din<=aludata; 
end

endmodule