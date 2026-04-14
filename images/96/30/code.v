module counter3bit_en(clk, rst, en, count);

    input  clk;
    input  rst;
    input  en;
    output reg [2:0] count;

    always @(posedge clk or posedge rst) begin
        if (rst)
            count <= 3'b000;
        else if (en)
            count <= count + 1;
    end
    
endmodule