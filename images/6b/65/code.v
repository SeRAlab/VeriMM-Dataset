module top_module(
    input A,
    input enable,
    input sleep,
    output reg X
);always @(A, enable, sleep) begin
    if (sleep) begin
        // If sleep is high, hold the output at the last value of A
        X <= X;
    end else if (enable) begin
        // If enable is high, pass the input signal to the output
        X <= A;
    end else begin
        // If enable is low, hold the output at the last value of A
        X <= X;
    end
end

endmodule