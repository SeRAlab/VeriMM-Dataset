module reg_32bit(clk, rst, en, D, Q);
    input clk;
    input rst;
    input en;
    input [31:0] D;
    output reg [31:0] Q;

    always @(posedge clk or posedge rst) begin
        if (rst)
            Q <= 32'b0;
        else if (en)
            Q <= D;
    end
endmodule