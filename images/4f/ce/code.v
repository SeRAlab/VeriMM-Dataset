module up_down_counter(clk, rst, up, count);

    input  clk;
    input  rst;
    input  up;
    output reg [3:0] count;

    always @(posedge clk or posedge rst) begin
        if (rst)
            count <= 4'b0000;
        else if (up)
            count <= count + 1;
        else
            count <= count - 1;
    end
    
endmodule