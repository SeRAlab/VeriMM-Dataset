module max_value(
    input [7:0] A,
    input [7:0] B,
    output reg [7:0] MAX
);

    always @(*) begin
        MAX = (A >= B) ? A : B;
    end

endmodule