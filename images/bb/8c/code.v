module top_module(
    input [3:0] A,
    input [3:0] B,
    input C,
    input clk,                // Added clk input here
    output reg [3:0] S,
    output reg OF,
    output reg CF
);wire [3:0] A_inv;
    wire [3:0] B_inv;
    wire [3:0] B_neg;
    wire [4:0] S_temp;

    // Calculate two's complement of B
    assign B_inv = ~B;
    assign B_neg = B_inv + 1;

    // Calculate A + B or A + B_neg based on C
    assign S_temp = (C == 1'b0) ? (A + B) : (A + B_neg);

    // Calculate overflow flag
    always @* begin
        OF = (S_temp[4] == 1);
    end

    // Calculate carry flag
    always @* begin
        CF = (S_temp[3] & (C == 1'b0)) | (S_temp[4] & (C == 1'b1));
    end

    // Assign S
    always @(posedge clk) begin
        S <= S_temp[3:0];
    end

endmodule