module top_module(clk, IRWr, imOut, instruction);input clk, IRWr;
    input [31:0] imOut;
    output reg [31:0] instruction;

    always @(posedge clk) begin
        if(IRWr) instruction <= imOut;
        else instruction <= instruction;
    end
endmodule