module top_module(Clk,Reset,PC,PC_Next);input Clk;
    input Reset;
    input [15:0] PC;
    output reg [15:0] PC_Next;
    
    always @ (posedge Clk)
    begin
        if(Reset)
        begin
           PC_Next = 0;
        end
        
        else
        begin
            PC_Next = PC + 1;
        end
    end
endmodule