module top_module(
    input [7:0] A,
    input [7:0] B,
    input CIN,
    input SUB,
    output reg [7:0] SUM,
    output reg OVF
);reg [8:0] temp_sum;
    reg [7:0] temp_a;
    reg [7:0] temp_b;

    always @(*) begin
        if (SUB == 1'b1) begin
            temp_a = A;
            temp_b = ~B + 1;
        end
        else begin
            temp_a = A;
            temp_b = B;
        end

        if (CIN == 1'b1) begin
            temp_sum = {1'b1, temp_a} + {1'b1, temp_b};
        end
        else begin
            temp_sum = temp_a + temp_b;
        end

        if (temp_sum[8] == 1'b1) begin
            OVF = 1'b1;
        end
        else begin
            OVF = 1'b0;
        end

        SUM = temp_sum[7:0];
    end

endmodule