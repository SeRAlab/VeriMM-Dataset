module up_down_counter_3bit(clk, rst, up_down, Q);
    input clk, rst, up_down;
    output reg [2:0] Q;

    always @(posedge clk) begin
        if (rst)
            Q <= 3'b000;
        else if (up_down)
            Q <= Q + 1;
        else
            Q <= Q - 1;
    end
endmodule