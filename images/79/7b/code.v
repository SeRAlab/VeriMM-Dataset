module counter_16bit(clk, rst, load, load_val, q);

    input clk;
    input rst;
    input load;
    input [15:0] load_val;
    output [15:0] q;
    reg [15:0] q;

    always @(posedge clk or posedge rst)
    begin
        if (rst)
            q <= 16'b0000000000000000;
        else if (load)
            q <= load_val;
        else
            q <= q + 1;
    end

endmodule