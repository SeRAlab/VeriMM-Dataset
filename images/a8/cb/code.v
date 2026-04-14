module up_counter(clk, rst, count);

    input clk;
    input rst;
    output [3:0] count;
    reg [3:0] count;

    always @(posedge clk)
    begin
        if (rst)
            count <= 4'b0000;
        else
            count <= count + 1;
    end

endmodule