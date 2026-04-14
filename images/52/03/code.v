module top_module(
    input [3:0] D0,
    input [3:0] D1,
    input [3:0] D2,
    input [3:0] D3,
    input LOAD,
    input RESET,
    input CLK,             // Added the CLK input
    output reg [3:0] Q0,
    output reg [3:0] Q1,
    output reg [3:0] Q2,
    output reg [3:0] Q3
);always @ (posedge CLK) begin
        if (RESET) begin
            Q0 <= 4'b0000;
            Q1 <= 4'b0000;
            Q2 <= 4'b0000;
            Q3 <= 4'b0000;
        end
        else if (LOAD) begin
            Q0 <= D0;
            Q1 <= D1;
            Q2 <= D2;
            Q3 <= D3;
        end
        else begin
            Q0 <= Q1;
            Q1 <= Q2;
            Q2 <= Q3;
            Q3 <= D0;
        end
    end

endmodule