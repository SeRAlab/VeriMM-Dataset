module binary_add_subtract(
    input [3:0] A,
    input [3:0] B,
    output [3:0] C
);

    wire [4:0] sum;

    assign sum = A + B;

    always @(*) begin
        if (sum > 9) begin
            C = sum - 6;
        end else begin
            C = sum;
        end
    end

endmodule