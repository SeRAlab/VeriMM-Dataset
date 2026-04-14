module top_module(
    input [3:0] A, B,
    input Rst,
    output reg [3:0] S,
    output reg Cout
);always @(*) begin
    if(Rst) begin
        S <= 4'b0;
        Cout <= 1'b0;
    end else begin
        S <= A + B;
        Cout <= (A[3] & B[3]) | (A[2] & B[2]) | (A[1] & B[1]) | (A[0] & B[0]);
    end
end

endmodule