module dff_4bit(clk, rst, D, Q);
    input clk;
    input rst;
    input [3:0] D;
    output reg [3:0] Q;

    always @(posedge clk) begin
        if (rst) begin
            Q <= 4'b0000;
        end else begin
            Q <= D;
        end
    end
endmodule