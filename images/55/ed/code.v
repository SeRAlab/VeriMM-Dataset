module top_module(
input clk,
output reg [5:0]boxnum
    );reg [5:0] num = 5'd0;
    
    always@(posedge clk)  begin
        if(num == 15) num <= 5'd0;
        else num <= num + 1;
    end
    
    always@(*) begin
        boxnum <= num;
    end    
endmodule