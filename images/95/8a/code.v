module top_module(clk, rst, WB_IN, ALUResIn, memReadIn, destIn,
                         WB_Out, ALUResOut, memReadOut,   destOut);input clk, rst;
    
    input [1:0] WB_IN;
    input [4:0] destIn;
    input [31:0] ALUResIn, memReadIn;
    
    output reg [1:0] WB_Out;
    output reg [4:0] destOut;
    output reg [31:0] ALUResOut, memReadOut;

    always @ (posedge clk) begin
        if (rst) begin
            {WB_Out, destOut, ALUResOut, memReadOut} <= 0;
        end
        else begin
            WB_Out <= WB_IN;
            destOut <= destIn;
            ALUResOut <= ALUResIn;
            memReadOut <= memReadIn;
        end
    end
endmodule