module top_module(
    input clk,
    input reset,
    input data_in,
    input shift_en,
    output reg data_out
);reg [7:0] shift_reg;

    always @(posedge clk) begin
        if (reset) begin
            shift_reg <= 8'b0;
        end else if (shift_en) begin
            shift_reg <= {shift_reg[6:0], data_in};
        end
    end

    assign data_out = shift_reg[7];

endmodule