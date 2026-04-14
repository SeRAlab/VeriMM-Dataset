module top_module(
    input clk,
    input ce,
    input rst,
    input [7:0] in_Y,
    input [7:0] in_Cb,
    input [7:0] in_Cr,
    input in_de,
    input in_vsync,
    input in_hsync,
    output reg [7:0] out_Y,
    output reg [7:0] out_Cb,
    output reg [7:0] out_Cr,
    output reg out_de,
    output reg out_vsync,
    output reg out_hsync
);reg [7:0] Y[0:2][0:82];
reg [7:0] Cb[0:2][0:82];
reg [7:0] Cr[0:2][0:82];
reg [7:0] Y_sum, Cb_sum, Cr_sum;
integer i, j;

always @(posedge clk) begin
    if (rst) begin
        for (i = 0; i <= 2; i = i + 1) begin
            for (j = 0; j <= 82; j = j + 1) begin
                Y[i][j] <= 8'h00;
                Cb[i][j] <= 8'h00;
                Cr[i][j] <= 8'h00;
            end
        end
    end else if (ce) begin
        // Shift in new pixel values
        Y[0][82] <= in_Y;
        Cb[0][82] <= in_Cb;
        Cr[0][82] <= in_Cr;

        // Shift rows - manual shift for each row
        for (j = 0; j < 83; j = j + 1) begin
            Y[2][j] <= Y[1][j]; // Shift row Y[1] to Y[2]
            Cb[2][j] <= Cb[1][j]; // Shift row Cb[1] to Cb[2]
            Cr[2][j] <= Cr[1][j]; // Shift row Cr[1] to Cr[2]
        end
        for (j = 0; j < 83; j = j + 1) begin
            Y[1][j] <= Y[0][j]; // Shift row Y[0] to Y[1]
            Cb[1][j] <= Cb[0][j]; // Shift row Cb[0] to Cb[1]
            Cr[1][j] <= Cr[0][j]; // Shift row Cr[0] to Cr[1]
        end

        // Calculate sum of 3x3 neighborhood
        Y_sum = Y[0][80] + Y[0][81] + Y[0][82] + Y[1][80] + Y[1][81] + Y[1][82] + Y[2][80] + Y[2][81] + Y[2][82];
        Cb_sum = Cb[0][80] + Cb[0][81] + Cb[0][82] + Cb[1][80] + Cb[1][81] + Cb[1][82] + Cb[2][80] + Cb[2][81] + Cb[2][82];
        Cr_sum = Cr[0][80] + Cr[0][81] + Cr[0][82] + Cr[1][80] + Cr[1][81] + Cr[1][82] + Cr[2][80] + Cr[2][81] + Cr[2][82];

        // Calculate mean of 3x3 neighborhood
        out_Y = Y_sum / 9;
        out_Cb = Cb_sum / 9;
        out_Cr = Cr_sum / 9;

        // Output sync signals
        out_de = in_de;
        out_vsync = in_vsync;
        out_hsync = in_hsync;
    end
end

endmodule