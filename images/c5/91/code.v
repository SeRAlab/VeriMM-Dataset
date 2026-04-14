module bitwise_and (
    input [3:0] a,
    input [3:0] b,
    output reg [3:0] and_result
);

    always @(*) begin
        and_result = a & b;
    end

endmodule