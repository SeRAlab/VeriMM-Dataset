module add_sub (
    input [3:0] A,
    input [3:0] B,
    input C,
    output reg [3:0] Q
);

    always @(*) begin
        if (C == 1) begin
            Q <= A + B;
        end else begin
            Q <= A - B;
        end
    end

endmodule