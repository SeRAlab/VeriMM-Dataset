module d_flip_flop_1bit(clk, rst, D, Q);
    input clk, rst, D;
    output reg Q;

    always @(posedge clk or posedge rst) begin
        if (rst)
            Q <= 1'b0;
        else
            Q <= D;
    end
endmodule