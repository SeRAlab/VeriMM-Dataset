module fir_filter (
    input wire clk,
    input wire rst,
    input wire [7:0] x0, x1, x2, x3, // 4 input samples
    input wire valid_in,
    output reg [15:0] y, // output sample
    output reg valid_out
);
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            y <= 0;
            valid_out <= 0;
        end else if (valid_in) begin
            y <= (1 * x0) + (2 * x1) + (3 * x2) + (4 * x3);
            valid_out <= 1;
        end else begin
            valid_out <= 0;
        end
    end
endmodule