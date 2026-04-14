module top_module(
    input clk,
    input reset,
    input d,
    input [7:0] input2,
    input [7:0] input3,
    input [7:0] input4,
    input sel_b1,
    input sel_b2,
    output [7:0] q
);reg [2:0] shift_reg;
    reg [7:0] mux_out;

    always @(posedge clk) begin
        if (reset) begin
            shift_reg <= 0;
        end else begin
            shift_reg <= {shift_reg[1:0], d};
        end
    end

    always @(*) begin
        if (sel_b1 == 0 && sel_b2 == 0) begin
            mux_out = shift_reg;
        end else if (sel_b1 == 0 && sel_b2 == 1) begin
            mux_out = input2;
        end else if (sel_b1 == 1 && sel_b2 == 0) begin
            mux_out = input3;
        end else if (sel_b1 == 1 && sel_b2 == 1) begin
            mux_out = input4;
        end
    end

    assign q = mux_out;

endmodule