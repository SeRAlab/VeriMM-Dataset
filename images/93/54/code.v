module top_module(
        input           iCLK,
        input           iWRMLR,
        input  [7:0]    iMULHB,
        output [7:0]    oMULRG
    );reg [7:0]       rMULRG = 8'h00;
    assign oMULRG = rMULRG;
    
    always@(posedge iCLK) begin
        if(iWRMLR) begin
            rMULRG <= iMULHB;
        end
        else begin
            rMULRG <= rMULRG;
        end
    end
endmodule