module top_module(
    input A,
    output reg Z3
);always @(*) begin
    if (A == 1'b1) begin
        Z3 = 1'b1;
    end else begin
        Z3 = 1'b0;
    end
end

endmodule