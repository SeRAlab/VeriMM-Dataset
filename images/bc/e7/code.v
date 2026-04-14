module top_module(
    adder,
    address,
    rst,
    clk,
);input clk;
input rst;
input [15:0] adder;
output [7:0] address;
reg   [15:0] count;
assign address[7:0] = count[15:8];
always @(posedge clk or posedge rst) begin
    if (rst) begin
        count <= 0;
    end
    else
    begin
        count <= count + adder;    
    end
end
endmodule