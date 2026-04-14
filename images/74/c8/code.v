module up_down_counter(clk, rst, dir, count);

    input  clk;
    input  rst;
    input  dir;
    output reg [2:0] count;

    always @(posedge clk or posedge rst) begin
        if (rst)
            count <= 3'b000;
        else if (dir)
            count <= count + 1;
        else
            count <= count - 1;
    end
    
endmodule