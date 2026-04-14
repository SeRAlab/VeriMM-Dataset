module mux2to1 (
    input [3:0] A,
    input [3:0] B,
    input sel,
    output reg [3:0] Y
);
    always @(*) begin
        if (sel == 1'b0)
            Y = A;
        else
            Y = B;
    end
endmodule