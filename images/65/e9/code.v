module top_module(
    input clk,
    input reset,
    input load,
    input shift_left,
    input shift_right,
    input [15:0] data_in,
    output [15:0] data_out
);parameter WIDTH = 4; // configurable width of shift register
    reg [15:0] shift_reg;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            shift_reg <= 0;
        end else if (load) begin
            shift_reg <= data_in;
        end else if (shift_left) begin
            shift_reg <= {shift_reg[15:WIDTH], shift_reg[WIDTH-1:0]}; // Correct order
        end else if (shift_right) begin
            shift_reg <= {shift_reg[14:0], shift_reg[15]}; // Correct order
        end
    end

    assign data_out = shift_reg;

endmodule