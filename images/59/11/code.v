module top_module(
    input clock,
    input reset,
    input signed [DIVIDEND_BIT_WIDTH-1:0] dividend,
    input signed [DIVISOR_BIT_WIDTH-1:0] divisor,
    output reg signed [DIVIDEND_BIT_WIDTH-1:0] quot_out,
    output reg signed [DIVIDEND_BIT_WIDTH-1:0] rem_out
);parameter DIVIDEND_BIT_WIDTH = 16;
parameter DIVISOR_BIT_WIDTH = 16;

always @(posedge clock or posedge reset) begin
    if (reset) begin
        quot_out <= 0;
        rem_out <= 0;
    end else begin
        if (divisor != 0) begin
            quot_out <= dividend / divisor;
            rem_out <= dividend % divisor;
        end else begin
            quot_out <= {DIVIDEND_BIT_WIDTH{1'bx}};  // Undefined behavior
            rem_out <= {DIVIDEND_BIT_WIDTH{1'bx}};   // Undefined behavior
        end
    end
end

endmodule