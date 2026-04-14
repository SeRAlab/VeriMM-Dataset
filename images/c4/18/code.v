module sum_of_products (
    input  wire        clk,
    input  wire        rst,
    input  wire [ 7:0] A,
    input  wire [ 7:0] B,
    output reg  [15:0] Z
);

    always @(posedge clk)
        if (rst) Z <= 16'd0;
        else     Z <= Z + (A * B);

endmodule