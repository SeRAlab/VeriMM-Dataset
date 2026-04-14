module add_sub (
    input [3:0] A,
    input [3:0] B,
    input sub,
    output [3:0] sum,
    output overflow
);

    reg [4:0] temp_sum;
    reg [3:0] temp_A;
    reg [3:0] temp_B;
    reg temp_sub;

    assign overflow = temp_sum[4];

    always @(*) begin
        temp_A = A;
        temp_B = B;
        temp_sub = sub;

        if (temp_sub == 1'b0) begin
            temp_sum = temp_A + temp_B;
        end
        else begin
            temp_sum = temp_A - temp_B;
        end
    end

    assign sum = temp_sum[3:0];

endmodule