module top_module(
    input clk,
    input data_in,
    input shift_in,
    input reset,
    output reg data_out
);reg [15:0] shift_reg;

always @(posedge clk) begin
    if (reset) begin
        shift_reg <= 16'b0;
        data_out <= 1'b0;
    end
    else begin
        if (shift_in) begin
            shift_reg <= {data_in, shift_reg[15:1]};
        end
        data_out <= shift_reg[15];
    end
end

endmodule