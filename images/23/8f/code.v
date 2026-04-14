module fft_4point (
    input wire clk,
    input wire rst,
    input wire [7:0] x_real_0, x_real_1, x_real_2, x_real_3,
    input wire [7:0] x_imag_0, x_imag_1, x_imag_2, x_imag_3,
    output reg [7:0] y_real_0, y_real_1, y_real_2, y_real_3,
    output reg [7:0] y_imag_0, y_imag_1, y_imag_2, y_imag_3
);

reg [7:0] stage1_real[3:0];
reg [7:0] stage1_imag[3:0];

always @(posedge clk or posedge rst) begin
    if (rst) begin
        y_real_0 <= 0; y_real_1 <= 0; y_real_2 <= 0; y_real_3 <= 0;
        y_imag_0 <= 0; y_imag_1 <= 0; y_imag_2 <= 0; y_imag_3 <= 0;
    end else begin
        // Stage 1: Compute butterfly operations
        stage1_real[0] <= x_real_0 + x_real_1;
        stage1_real[1] <= x_real_0 - x_real_1;
        stage1_real[2] <= x_real_2 + x_real_3;
        stage1_real[3] <= x_real_2 - x_real_3;

        stage1_imag[0] <= x_imag_0 + x_imag_1;
        stage1_imag[1] <= x_imag_0 - x_imag_1;
        stage1_imag[2] <= x_imag_2 + x_imag_3;
        stage1_imag[3] <= x_imag_2 - x_imag_3;

        // Stage 2: Combine results
        y_real_0 <= stage1_real[0] + stage1_real[2];
        y_imag_0 <= stage1_imag[0] + stage1_imag[2];
        
        y_real_1 <= stage1_real[1] + stage1_real[3]; // W factor omitted for simple case
        y_imag_1 <= stage1_imag[1] + stage1_imag[3]; // W factor omitted for simple case
        
        y_real_2 <= stage1_real[0] - stage1_real[2];
        y_imag_2 <= stage1_imag[0] - stage1_imag[2];

        y_real_3 <= stage1_real[1] - stage1_real[3]; // W factor omitted for simple case
        y_imag_3 <= stage1_imag[1] - stage1_imag[3]; // W factor omitted for simple case
    end
end

endmodule