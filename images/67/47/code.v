module top_module(
    input clk,
    input reset,
    input [7:0] A,
    input [7:0] B,
    output reg [15:0] P
);reg [7:0] A_reg;
reg [7:0] B_reg;
reg [15:0] P_reg;

always @(posedge clk) begin
    if (reset) begin
        A_reg <= 0;
        B_reg <= 0;
        P_reg <= 0;
    end else begin
        A_reg <= A;
        B_reg <= B;
        P_reg <= A_reg * B_reg;
    end
end

always @(posedge clk) begin
    if (reset) begin
        P <= 0;
    end else begin
        P <= P_reg;
    end
end

endmodule