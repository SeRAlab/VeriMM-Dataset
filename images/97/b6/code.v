module counter_4bit_sync(clk, rst, Q);
    input clk, rst;
    output reg [3:0] Q;

    always @(posedge clk) begin
        if (rst)
            Q <= 4'b0000;
        else
            Q <= Q + 1;
    end
endmodule