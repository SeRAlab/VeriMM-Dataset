module top_module(
    input clk,
    input reset,
    output vsync,
    output hsync,
    output [2:0] VGA_R,
    output [2:0] VGA_G,
    output [1:0] VGA_B,
    output [9:0] x_ptr,
    output [9:0] y_ptr
);parameter HPIXELS = 800;
    parameter VLINES = 521;
    parameter HBP = 144;
    parameter HFP = 784;
    parameter VBP = 31;
    parameter VFP = 511;

    reg [9:0] x_cnt;
    reg [9:0] y_cnt;
    reg [9:0] cnt;

    wire valid;
    reg [7:0] color;  // Added line to declare the color register

    assign x_ptr = x_cnt - HBP;
    assign y_ptr = y_cnt - VBP;

    always @(posedge clk) begin
        if (reset) begin
            cnt <= 0;
            x_cnt <= 0;
            y_cnt <= 0;
            color <= 8'b11111111; // Example color, can be set as desired
        end
        else begin
            cnt <= cnt + 1;
            if (x_cnt == HPIXELS - 1) begin
                x_cnt <= 0;
                if (y_cnt == VLINES - 1) begin
                    y_cnt <= 0;
                end
                else begin
                    y_cnt <= y_cnt + 1;
                end
            end
            else begin
                x_cnt <= x_cnt + 1;
            end
        end
    end

    assign hsync = (x_cnt >= HBP) && (x_cnt <= HFP);
    assign vsync = (y_cnt >= VBP) && (y_cnt <= VFP);

    assign VGA_R = valid ? {color[7], color[7], color[7]} : 3'b000; // Changed 0 to 3'b000
    assign VGA_G = valid ? {color[4], color[4], color[4]} : 3'b000; // Changed 0 to 3'b000
    assign VGA_B = valid ? {color[1], color[1]} : 2'b00; // Changed 0 to 2'b00

    assign valid = (x_cnt >= HBP) && (x_cnt <= HFP) && (y_cnt >= VBP) && (y_cnt <= VFP);

endmodule