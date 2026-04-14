module top_module(
    input clk,
    input reset,            // Asynchronous reset
    input [3:0] d,
    input enable,
    output [3:0] q,
    output [3:0] or_output
);reg [3:0] shift_reg;
    reg [3:0] or_result;

    always @(negedge clk) begin
        if (reset) begin
            shift_reg <= 4'b0;
        end else if (enable) begin
            shift_reg <= {d, shift_reg[3:1]};
        end
    end

    assign q = shift_reg;
    assign or_output = or_result;

    always @(shift_reg or d or enable) begin
        or_result = shift_reg | d;
    end

endmodule