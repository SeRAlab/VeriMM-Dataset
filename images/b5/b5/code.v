module register_8bit(clk, rst, en, D, Q);
    input clk, rst, en;
    input [7:0] D;
    output reg [7:0] Q;

    always @(posedge clk or posedge rst) begin
        if (rst)
            Q <= 8'b00000000;
        else if (en)
            Q <= D;
    end
endmodule