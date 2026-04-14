module binary_adder (
    input [7:0] A,
    input [7:0] B,
    input C,
    output reg [7:0] S
);

    always @(*) begin
        if (C) begin
            S <= A - B;
        end else begin
            S <= A + B;
        end
    end

endmodule