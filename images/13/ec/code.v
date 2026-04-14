module fir_filter (
    input [7:0] x,
    input clk,
    input rst,
    output reg [7:0] y
);

reg [7:0] coeff[0:7]; // 8 coefficients
reg [7:0] shift_reg[0:7]; // Shift register for input samples
integer i;

initial begin
    // Initialize filter coefficients (example values)
    coeff[0] = 8'd1;
    coeff[1] = 8'd2;
    coeff[2] = 8'd3;
    coeff[3] = 8'd4;
    coeff[4] = 8'd5;
    coeff[5] = 8'd6;
    coeff[6] = 8'd7;
    coeff[7] = 8'd8;
end

always @(posedge clk or posedge rst) begin
    if (rst) begin
        // Reset output and shift register
        y <= 8'd0;
        for (i = 0; i < 8; i = i + 1) begin
            shift_reg[i] <= 8'd0;
        end
    end else begin
        // Shift input samples
        for (i = 7; i > 0; i = i - 1) begin
            shift_reg[i] <= shift_reg[i - 1];
        end
        shift_reg[0] <= x;

        // Calculate output
        y <= 8'd0; // Reset output
        for (i = 0; i < 8; i = i + 1) begin
            y <= y + (shift_reg[i] * coeff[i]);
        end
    end
end

endmodule