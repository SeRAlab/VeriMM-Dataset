module top_module(clk,  reg1, reg2, result, ramdata,aluA, aluB, ramadd, wdata,DBDataSrc);input clk, DBDataSrc;
    input[31:0] reg1, reg2, result, ramdata;
    output reg [31:0] aluA, aluB, ramadd, wdata;
    always@(posedge clk) begin    
            aluA = reg1;
            aluB = reg2;
            ramadd = result;
            wdata = DBDataSrc ? ramdata : result;
        end
endmodule