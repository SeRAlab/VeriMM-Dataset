module comparator_16bit (
    input [15:0] A,
    input [15:0] B,
    output reg A_gt,
    output reg A_eq,
    output reg A_lt
);

always @(*) begin
    if (A > B) begin
        A_gt = 1;
        A_eq = 0;
        A_lt = 0;
    end else if (A == B) begin
        A_gt = 0;
        A_eq = 1;
        A_lt = 0;
    end else begin
        A_gt = 0;
        A_eq = 0;
        A_lt = 1;
    end
end

endmodule