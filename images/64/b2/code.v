module top_module(
    input clk,
    
    input [31:0] ALUresult,op2,ctrl,pcin2,
    input [4:0] rd, 
    output reg [31:0] ctrlm,y,bm,pcin3,
    output reg [4:0] rdm
    
    );always @(posedge clk) begin
        y <= ALUresult;
        bm <= op2;
        ctrlm <= ctrl;
        pcin3 <= pcin2;
        rdm <=rd;
        
    end
endmodule