module up_down_counter_4bit(clk, up_down, count);

    input  clk, up_down;
    output reg [3:0] count;

    always @(posedge clk) begin
        if (up_down)
            count <= count + 1;
        else
            count <= count - 1;
    end

endmodule