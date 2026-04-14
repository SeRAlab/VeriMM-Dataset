module top_module(
        input [3:0] dataA_d,
        input [3:0] dataB_d,
        input [1:0] sum10,
        input clk,
        input reset_L_d,
        output reg [3:0] dataA_dd,
        output reg [3:0] dataB_dd,
        output reg [1:0] sum10_d,
        output reg [1:0] reset_L_dd
    );always @(posedge clk)begin
        dataA_dd <= dataA_d;
        dataB_dd <= dataB_d;
        sum10_d <= sum10;
        reset_L_dd <= reset_L_d;

    end
endmodule