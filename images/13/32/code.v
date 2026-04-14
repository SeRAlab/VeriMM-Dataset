module mux2to1 (
    input [7:0] A,
    input [7:0] B,
    input S,
    output reg [7:0] Y
);
    always @(*) begin
        if (S) begin
            Y = B;
        end else begin
            Y = A;
        end
    end
endmodule