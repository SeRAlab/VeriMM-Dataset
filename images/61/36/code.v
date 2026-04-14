module top_module(Clk,Clrn,M_Wreg,M_Reg2reg,M_ALUR,M_Dout,M_Rd,W_Wreg,W_Reg2reg,W_ALUR,W_Dout,W_Rd);input Clk,Clrn;
    input M_Wreg,M_Reg2reg;
    input [31:0]M_ALUR,M_Dout;
    input [4:0]M_Rd;
    output reg W_Wreg,W_Reg2reg;
    output reg [31:0]W_ALUR,W_Dout;
    output reg [4:0]W_Rd;
    always@ (posedge Clk or negedge Clrn)
        if(Clrn==0)begin
            W_Wreg<=0;          W_Reg2reg<=0;
            W_ALUR<=0;          W_Dout<=0;
            W_Rd<=0;
        end else begin
            W_Wreg<=M_Wreg;     W_Reg2reg<=M_Reg2reg;
            W_ALUR<=M_ALUR;     W_Dout<=M_Dout;
            W_Rd<=M_Rd;
        end
endmodule