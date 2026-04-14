module top_module(
    input clk,
    input reset,
    input enable,
    input [255:0] in,
    input [7:0] sel,
    output reg final_output
);reg [7:0] mux_output;
    reg [2:0] shift_reg;
    reg [7:0] shift_reg_output;

    always @(posedge clk) begin
        if (reset) begin
            mux_output <= 0;
            shift_reg <= 0;
            shift_reg_output <= 0;
        end else begin
            mux_output <= in[sel];
            if (enable) begin
                shift_reg <= {shift_reg[1:0], mux_output};
                shift_reg_output <= {shift_reg[2], shift_reg[1], shift_reg[0]};
            end else begin
                shift_reg_output <= 0;
            end
        end
    end

    always @(shift_reg_output) begin
        final_output <= shift_reg_output & mux_output;
    end

endmodule