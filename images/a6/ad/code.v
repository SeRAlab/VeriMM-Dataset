module top_module(
    input [3:0] a,
    input [3:0] b,
    input sub,
    input cin,
    output reg cout,
    output reg overflow,
    output reg [3:0] sum
);reg [4:0] temp_sum;
    reg [4:0] temp_a;
    reg [4:0] temp_b;
    reg temp_sub;

    always @(*) begin
        temp_a = {1'b0, a};
        temp_b = {1'b0, b};
        temp_sub = sub;
        if (cin) temp_sum[0] = 1'b1;
        else temp_sum[0] = 1'b0;
        if (temp_sub) begin
            temp_b = ~temp_b + 1;
        end
        temp_sum = temp_a + temp_b + cin;
        if (temp_sum[4] != temp_sum[3]) overflow = 1'b1;
        else overflow = 1'b0;
        sum = temp_sum[3:0];
        cout = temp_sum[4];
    end

endmodule