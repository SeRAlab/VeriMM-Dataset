module top_module(
    input clk,
    input reset,
    input [3:0] shift_in,
    input shift_en,
    input capture_en,
    input [3:0] capture_in,
    output reg [3:0] shift_out,
    output reg [3:0] capture_out
);reg [3:0] shift_reg;
    reg [3:0] capture_reg;

    always @(posedge clk) begin
        if (reset) begin
            shift_reg <= 4'b0;
            capture_reg <= 4'b0;
        end else begin
            if (shift_en) begin
                shift_reg <= {shift_reg[2:0], shift_in};
            end
            if (capture_en) begin
                capture_reg <= capture_in;
            end
        end
    end

    assign shift_out = shift_reg;
    assign capture_out = capture_reg;

endmodule