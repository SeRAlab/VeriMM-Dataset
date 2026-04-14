module top_module(
input clk,
output reg [7:0]random_num
    );reg [7:0] count = 8'd11;
    
    always@(*) begin
    random_num = count;
    end
    
    always@(posedge clk)
    if(count == 8'hff) count <= 8'd11;
    else count <= count + 1;
    
endmodule