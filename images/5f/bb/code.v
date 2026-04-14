module top_module(
    input clk,
    input rst,
    input signed [15:0] x_in,
    input signed [19:0] coeff_in,
    output signed [31:0] y_out
);reg signed [15:0] x_reg [8:0];
    reg signed [19:0] coeff_reg [3:0];
    reg signed [31:0] y_reg;

    integer i;

    always @(posedge clk) begin
        if (rst) begin
            for (i = 0; i < 9; i = i + 1) begin
                x_reg[i] <= 0;
            end
            for (i = 0; i < 4; i = i + 1) begin
                coeff_reg[i] <= 0;
            end
            y_reg <= 0;
        end else begin
            for (i = 8; i > 0; i = i - 1) begin
                x_reg[i] <= x_reg[i - 1];
            end
            x_reg[0] <= x_in;
            for (i = 3; i > 0; i = i - 1) begin
                coeff_reg[i] <= coeff_reg[i - 1];
            end
            coeff_reg[0] <= coeff_in;
            y_reg <= 0;
            for (i = 0; i < 4; i = i + 1) begin
                y_reg <= y_reg + (x_reg[i] * coeff_reg[i]);
            end
        end
    end

    assign y_out = y_reg;

endmodule