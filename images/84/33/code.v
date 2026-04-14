module top_module(
        input           iCLK,
        input           iPCRST,
        input           iPCJEN,
        input  [7:0]    iPCJIN,
        output [7:0]    oIADDR
    );reg [7:0]       rPC = 8'h00;
    assign oIADDR = rPC;
    
    always@(posedge iCLK) begin
        if(iPCRST) begin
            rPC <= 8'h00;
        end
        else begin
            if(iPCJEN) begin
                rPC <= iPCJIN;
            end
            else begin
                rPC <= rPC + 8'd1;
            end
        end
    end
endmodule