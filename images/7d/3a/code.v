module top_module(clk, reset, threshVal, thr, count);input clk;
    input reset;
    input [3:0] threshVal;
    output reg thr;
    output reg [3:0] count = 4'b0001;
    
    
    
    always@(posedge clk or posedge reset) begin
        if(reset) begin
            count <= 4'b0001;
            thr <= 0;
        end
        else begin
            if(count == threshVal) begin
                count <= 4'b0000;
                thr <= 1;
            end
            else begin
                count <= count + 4'b0001;
                thr <= 0;
            end
        end
    end
    
endmodule