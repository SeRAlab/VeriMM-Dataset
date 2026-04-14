module adder_4bit (
    A,
    B,
    Z
);

    input [3:0] A;
    input [3:0] B;
    output [3:0] Z;

    wire [4:0] temp_sum;

    assign temp_sum = A + B;

    always @(*) begin
        if (temp_sum > 15) begin
            Z = 4'b1111;
        end else begin
            Z = temp_sum[3:0];
        end
    end

endmodule