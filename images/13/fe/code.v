module max_finder (
    input [4:0] A,
    input [4:0] B,
    input [4:0] C,
    output reg [4:0] max_out
);
    always @(*) begin
        if (A >= B && A >= C)
            max_out = A;
        else if (B >= A && B >= C)
            max_out = B;
        else
            max_out = C;
    end
endmodule