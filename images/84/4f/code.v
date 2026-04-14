module counter_4bit_async_reset(clk, reset, count);

    input  clk, reset;
    output reg [3:0] count;

    always @(posedge clk or posedge reset) begin
        if (reset)
            count <= 0;
        else
            count <= count + 1;
    end

endmodule