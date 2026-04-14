module top_module(
    input A1,
    input A2,
    input B1,
    input C1,
    output reg [1:0] Y
);always @(*) begin
    if (B1 == 1 && C1 == 0) begin
        Y = A1 - A2;
    end else if (B1 == 1 && C1 == 1) begin
        Y = A1 * A2;
    end else begin
        Y = A1 + A2;
    end
end

endmodule