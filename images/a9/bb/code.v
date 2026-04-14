module top_module(
    input [7:0] D,
    input clk,          // Added the clk input
    output reg P
);reg [3:0] count1;
reg [3:0] count2;
reg [3:0] count3;
reg [3:0] count4;

wire [3:0] sum1;
wire [3:0] sum2;
wire [3:0] sum3;

assign sum1 = count1 + count2;
assign sum2 = count3 + count4;
assign sum3 = sum1 + sum2;

always @ (posedge clk) begin
    count1 <= D[0] + D[1] + D[2] + D[3];
    count2 <= D[4] + D[5] + D[6] + D[7];
    count3 <= sum1[0] + sum1[1] + sum1[2] + sum1[3];
    count4 <= sum2[0] + sum2[1] + sum2[2] + sum2[3];
    P <= ~sum3[0];
end

endmodule