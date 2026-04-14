module up_counter(clk, rst, en, count);
    input clk, rst, en;
    output reg [2:0] count;

    always @(posedge clk) begin
        if (rst)
            count <= 3'b000;
        else if (en)
            count <= count + 1'b1;
    end
endmodule