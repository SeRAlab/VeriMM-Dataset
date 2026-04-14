module butterworth_filter (
    input [7:0] x_in,
    input clk,
    output reg [7:0] y_out
);
    reg [8:0] x1, x2;
    reg [8:0] y1, y2;

    always @(posedge clk) begin
        // Assume simple coefficients for a 2nd-order filter
        // y = (0.5 * x) + (0.25 * x1) + (0.125 * x2) - (0.25 * y1) - (0.125 * y2)
        
        // Shift previous values
        x2 <= x1;
        x1 <= x_in;

        y2 <= y1;
        y1 <= (x_in * 9'd128 + x1 * 9'd64 + x2 * 9'd32 - y1 * 9'd64 - y2 * 9'd32) >> 8;

        y_out <= y1[7:0];
    end
endmodule