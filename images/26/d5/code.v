module nearest_neighbor_interp(
    input [4:0] A,
    input [4:0] B,
    input [4:0] X,
    output reg [4:0] Y
);
    always @(*) begin
        if (X < A) begin
            Y = A;
        end else if (X >= A && X < B) begin
            Y = A;
        end else begin
            Y = B;
        end
    end
endmodule