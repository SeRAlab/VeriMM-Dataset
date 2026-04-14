module binary_counter(
    input clk,
    input rst,
    output reg [3:0] count
);
    always @(posedge clk or posedge rst)
        if (rst)
            count <= 4'b0000;
        else
            count <= count + 1;
endmodule