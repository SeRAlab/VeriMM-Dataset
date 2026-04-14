module counter_3bit(clk, reset, count);

    input clk, reset;
    output reg [2:0] count;

    always @(posedge clk)
        begin
            if (reset)
                count <= 3'b000;
            else
                count <= count + 1;
        end

endmodule