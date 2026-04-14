module top_module(
    output reg [1:0]dataOut,
    input [1:0]dataIn0,
    input [1:0]dataIn1,
    input selector,
    input clk,
    input reset);reg [1:0]out;

    
    always @(*)
        begin
            if(selector==0) 
                out=dataIn0;
            else
                out=dataIn1;
        end
    
    always @(posedge clk)
        begin
            if(reset == 1)
                dataOut <= out;
            else
                dataOut <= 2'b0;
        end
endmodule