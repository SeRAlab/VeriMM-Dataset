module top_module(
    input  wire        clk,
    input  wire [ 7:0] A,
    input  wire [ 7:0] B,
    output reg  [15:0] Z
);reg [7:0] A_abs;
    reg [7:0] B_abs;
    reg        A_sign;
    reg        B_sign;

    always @(*) begin
        A_abs = (A < 0) ? (~A + 1) : A;
        B_abs = (B < 0) ? (~B + 1) : B;
        A_sign = (A < 0);
        B_sign = (B < 0);
    end

    reg [15:0] prod;
    reg [23:0] prod_shifted;

    always @(posedge clk) begin
        prod = A_abs * B_abs;
        prod_shifted = {prod, 8'b0};
        if (A_sign ^ B_sign) begin
            Z <= (~prod_shifted) + 1;
        end else begin
            Z <= prod_shifted;
        end
    end

endmodule