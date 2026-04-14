module counter_16bit_up_down(clk, rst, dir, count);
    input clk;
    input rst;
    input dir;
    output reg [15:0] count;

    always @(posedge clk) begin
        if (rst)
            count <= 16'b0;
        else if (dir)
            count <= count + 1;
        else
            count <= count - 1;
    end
endmodule