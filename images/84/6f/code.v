module top_module(
    input clk,
    input reset,
    input data_in,
    output reg pattern_detected);reg [2:0] shift_reg;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            shift_reg <= 3'b000;
            pattern_detected <= 0;
        end else begin
            shift_reg <= {shift_reg[1:0], data_in};
            if (shift_reg == 3'b101) begin
                pattern_detected <= 1;
            end else begin
                pattern_detected <= 0;
            end
        end
    end

endmodule