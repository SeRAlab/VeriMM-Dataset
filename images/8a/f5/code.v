module gray_counter(clk, rst, gray);

    input clk;
    input rst;
    output [4:0] gray;
    reg [4:0] bin;
    reg [4:0] gray;

    always @(posedge clk)
    begin
        if (rst)
            bin <= 5'b00000;
        else
            bin <= bin + 1;
    end

    always @(*)
    begin
        gray = bin ^ (bin >> 1);
    end

endmodule