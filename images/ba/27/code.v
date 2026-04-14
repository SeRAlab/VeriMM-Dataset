module counter_3bit(clk, reset, up_down, count);

    input clk;
    input reset;
    input up_down;
    output [2:0] count;
    reg [2:0] count;

    always @(posedge clk or posedge reset)
        begin
            if (reset)
                count <= 0;
            else if (up_down)
                count <= count + 1;
            else
                count <= count - 1;
        end

endmodule