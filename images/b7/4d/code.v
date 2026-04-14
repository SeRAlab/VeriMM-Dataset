module top_module(
    input [15:0] datain,
    input ExtSel,
    output reg [31:0] result
    );always@(datain or ExtSel) begin
        result[15:0]<=datain[15:0];
        if(ExtSel==1 && datain[15]==1)
            result[31:16]<=16'b1111_1111_1111_1111;
        else
            result[31:16]=0;
    end
endmodule