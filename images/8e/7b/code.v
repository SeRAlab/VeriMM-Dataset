module top_module(
    input up_down,
    input load,
    input shift,
    input clk,
    input reset,
    input [15:0] data_in,
    output [15:0] data_out
);reg [15:0] counter;
    reg [15:0] shift_reg;

    always @(posedge clk) begin
        if (reset) begin
            counter <= 16'd0;
            shift_reg <= 16'd0;
        end else if (load) begin
            counter <= data_in;
            shift_reg <= data_in;
        end else if (shift) begin
            counter <= up_down ? counter + 1 : counter - 1;
            shift_reg <= {shift_reg[14:0], counter};
        end
    end

    assign data_out = shift_reg;

endmodule