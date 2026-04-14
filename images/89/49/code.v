module binary_counter_3bit(clk, rst, Q);
    input clk, rst;
    output reg [2:0] Q;

    always @(posedge clk) begin
        if (rst)
            Q <= 3'b000;
        else
            Q <= Q + 1;
    end
endmodule