module top_module(clk,A,Y);input wire clk;
input wire A;
output reg Y;

always @(posedge clk) begin
    Y <= A;
end
endmodule