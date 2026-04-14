module top_module(
    input clk,
    input [7:0] boundary,
    input input_enable,
    input [8:0] base,
    output reg [7:0] exponent,
    output reg ready
);reg [7:0] current_exponent;
reg [8:0] current_value;

always @(posedge clk) begin
    if (input_enable) begin
        if (current_exponent == boundary) begin
            exponent <= 0;
            ready <= 1;
            current_exponent <= 0;
            current_value <= 1;
        end else begin
            current_value <= current_value * base;
            current_exponent <= current_exponent + 1;
            if (current_value == base) begin
                exponent <= current_exponent;
                ready <= 1;
                current_exponent <= 0;
                current_value <= 1;
            end
        end
    end else begin
        exponent <= 0;
        ready <= 0;
        current_exponent <= 0;
        current_value <= 1;
    end
end

endmodule