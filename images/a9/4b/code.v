module binary_counter_4bit(clk, rst, en, Q);
    input clk, rst, en;
    output reg [3:0] Q;

    always @(posedge clk) begin
        if (rst)
            Q <= 4'b0000;
        else if (en)
            Q <= Q + 1;
    end
endmodule