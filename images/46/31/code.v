module top_module(
    input [7:0] A,
    input [7:0] B,
    output reg [7:0] max
);always @(*) begin
    if (A > B) begin
        max = A;
    end else if (B > A) begin
        max = B;
    end else begin
        max = 0;
    end
end

endmodule