module fir_filter (
    input wire clk,
    input wire reset,
    input wire [3:0] x, // 4-bit input
    output reg [1:0] y // 2-bit output
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            y <= 2'b00;
        end else begin
            y <= (1 * x[0] + 2 * x[1] + 1 * x[2] + 0 * x[3]);
        end
    end
endmodule