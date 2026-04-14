module top_module(
    input [3:0] D0,
    input [3:0] D1,
    input [3:0] D2,
    input [3:0] D3,
    input LOAD,
    input RESET,
    input CLK, // Added CLK input here
    output reg [3:0] Q0,
    output reg [3:0] Q1,
    output reg [3:0] Q2,
    output reg [3:0] Q3
);reg [3:0] reg1, reg2, reg3, reg4;

always @(posedge LOAD or posedge RESET) begin
    if (RESET) begin
        reg1 <= 4'b0000;
        reg2 <= 4'b0000;
        reg3 <= 4'b0000;
        reg4 <= 4'b0000;
    end
    else if (LOAD) begin
        reg1 <= D0;
        reg2 <= D1;
        reg3 <= D2;
        reg4 <= D3;
    end
end

always @(posedge CLK) begin
    Q0 <= reg1;
    Q1 <= reg2;
    Q2 <= reg3;
    Q3 <= reg4;
    reg1 <= D0;
    reg2 <= reg1;
    reg3 <= reg2;
    reg4 <= reg3;
end

endmodule