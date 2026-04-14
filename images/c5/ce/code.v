module adder(
    input [3:0] A,
    input [3:0] B,
    output reg [3:0] Z
);

    always @(*) begin
        if((A+B) > 9) begin
            Z = (A+B) % 10;
        end
        else begin
            Z = A+B;
        end
    end

endmodule