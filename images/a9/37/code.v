module top_module(
    input clk,
    output reg [3:0] Q
);reg [3:0] Q1, Q2, Q3, Q4;

always @(posedge clk) begin
    Q4 <= Q3;
    Q3 <= Q2;
    Q2 <= Q1;
    Q1 <= Q;
end

always @(posedge clk) begin
    case(Q4)
        4'b0000: Q <= 4'b0001;
        4'b0001: Q <= 4'b0011;
        4'b0011: Q <= 4'b0010;
        4'b0010: Q <= 4'b0110;
        4'b0110: Q <= 4'b0111;
        4'b0111: Q <= 4'b0101;
        4'b0101: Q <= 4'b0100;
        4'b0100: Q <= 4'b1100;
        4'b1100: Q <= 4'b1101;
        4'b1101: Q <= 4'b1111;
        4'b1111: Q <= 4'b1110;
        4'b1110: Q <= 4'b1010;
        4'b1010: Q <= 4'b1011;
        4'b1011: Q <= 4'b1001;
        4'b1001: Q <= 4'b1000;
        4'b1000: Q <= 4'b0000;
    endcase
end

endmodule