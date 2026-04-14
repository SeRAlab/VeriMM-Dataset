module bidir_counter(clk, rst, up, q);

    input  clk;
    input  rst;
    input  up;
    output reg [1:0] q;

    always @(posedge clk or posedge rst) begin
        if (rst)
            q <= 2'b00;
        else if (up)
            q <= q + 1;
        else
            q <= q - 1;
    end
    
endmodule