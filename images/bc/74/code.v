module binary_counter(clk, rst, en, load, data, q);

    input clk;
    input rst;
    input en;
    input load;
    input [3:0] data;
    output [3:0] q;
    reg [3:0] q;

    always @(posedge clk)
    begin
        if (rst)
            q <= 4'b0000;
        else if (load)
            q <= data;
        else if (en)
            q <= q + 1;
    end

endmodule