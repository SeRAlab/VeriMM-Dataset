module DWT_Haar (
    input clk,
    input rst,
    input [3:0] signal_in,
    output reg [3:0] coeff_a,
    output reg [3:0] coeff_d
);
    reg [3:0] temp_a;
    reg [3:0] temp_d;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            coeff_a <= 4'b0;
            coeff_d <= 4'b0;
        end else begin
            temp_a <= (signal_in[3:2] + signal_in[1:0]) >> 1; // averaging
            temp_d <= (signal_in[3:2] - signal_in[1:0]); // differencing
            coeff_a <= temp_a;
            coeff_d <= temp_d;
        end
    end
endmodule