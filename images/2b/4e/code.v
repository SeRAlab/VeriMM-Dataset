module mux2to1 (
    input [3:0] A,
    input [3:0] B,
    input sel,
    output reg [3:0] Y
);
    always @(*) begin
        if (sel)
            Y = B;
        else
            Y = A;
    end
endmodule