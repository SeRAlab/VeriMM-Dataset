module top_module(
    input Clock,
    input Clear,
    input Enable,
    input Load,
    output reg [1:0] Q
);always @(posedge Clock) begin
    if (Clear) begin
        Q <= 2'b0;
    end else if (Load) begin
        Q <= 2'b11;
    end else if (Enable) begin
        Q <= Q + 1;
    end
end

endmodule