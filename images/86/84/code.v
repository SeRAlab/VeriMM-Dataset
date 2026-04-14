module gray_counter(clk, rst, q);

    input  clk;
    input  rst;
    output reg [5:0] q;
    reg [5:0] bin; // binary counter

    always @(posedge clk or posedge rst) begin
        if (rst)
            bin <= 6'b000000;
        else
            bin <= bin + 1;
    end

    always @(posedge clk or posedge rst) begin
        if (rst)
            q <= 6'b000000;
        else
            q <= bin ^ (bin >> 1);
    end
    
endmodule