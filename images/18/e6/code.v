module adder_5bit (
    input [4:0] A,
    input [4:0] B,
    input EN,
    output reg [5:0] S
);
    always @(*) begin
        if (EN) begin
            S = A + B;
        end else begin
            S = 6'b000000;
        end
    end
endmodule