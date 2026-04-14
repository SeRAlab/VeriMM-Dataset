module top_module(
    input A,
    input B,
    input power_good,
    output reg out
);always @(*) begin
    if (A && B && power_good) begin
        out <= 1'b1; // Set out to high
    end else begin
        out <= 1'b0; // Set out to low
    end
end

endmodule