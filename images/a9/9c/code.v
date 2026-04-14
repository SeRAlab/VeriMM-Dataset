module top_module(
    input A,
    input B,
    input C,
    output reg X
);always @(*) begin
    if (A & B & C) begin
        X = 1'b1;
    end else begin
        X = 1'b0;
    end
end

endmodule