module fir_filter (
    input wire clk,
    input wire reset,
    input wire [7:0] sample_in,
    output reg [7:0] sample_out
);
    reg [7:0] coeff [0:7]; // Coefficients for the FIR filter
    reg [7:0] shift_reg [0:7]; // Shift register for input samples
    integer i;

    initial begin
        coeff[0] = 8'd1;
        coeff[1] = 8'd2;
        coeff[2] = 8'd3;
        coeff[3] = 8'd4;
        coeff[4] = 8'd5;
        coeff[5] = 8'd6;
        coeff[6] = 8'd7;
        coeff[7] = 8'd8;
    end

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            sample_out <= 8'd0;
            for (i = 0; i < 8; i = i + 1) begin
                shift_reg[i] <= 8'd0;
            end
        end else begin
            // Shift the samples
            for (i = 7; i > 0; i = i - 1) begin
                shift_reg[i] <= shift_reg[i-1];
            end
            shift_reg[0] <= sample_in;

            // Calculate the output
            sample_out <= 8'd0;
            for (i = 0; i < 8; i = i + 1) begin
                sample_out <= sample_out + (shift_reg[i] * coeff[i]);
            end
        end
    end
endmodule