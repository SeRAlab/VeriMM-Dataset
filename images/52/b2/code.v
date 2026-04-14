module top_module(
    input clk,               // the system clock
    input [15:0] data_in,    // the value of the register to show
    input [10:0] vga_h,      // the current vertical pixel count being displayed
    input [10:0] vga_v,      // the current horizontal pixel count being displayed
    input [2:0] bg,          // the colour of the background pixel
    output [2:0] pixel_out,  // The requested  pixel value at vga_h x vga_v
    output display_on        // whether the screen should be displaying this
 );parameter START_H = 10;  // horizontal pixel where this should appear on the screen
    parameter START_V = 380; // vertical pixel where this should appear on the screen

    reg [2:0] out = 0;
    assign pixel_out = out;
    reg on = 0;
    assign display_on = on;

    reg [4:0] row = 0;
    reg [4:0] col = 0;
    reg [15:0] data_out = 0;

    always @ (posedge clk) begin
        if (vga_v >= START_V && vga_v < START_V + 11'd6
        && vga_h >= START_H && vga_h < START_H + 11'd161) begin
            on <= 1'b1;
            row <= vga_v - START_V;
            col <= vga_h - START_H;
            data_out <= data_in;
            // 5 x 5 squares that light if the corresponding bit in the data is set.
            case (row)
                5'd0: out <= data_out[15 - col] ? 3'b100 : 3'b000;
                5'd1: out <= data_out[10 - col] ? 3'b100 : 3'b000;
                5'd2: out <= data_out[5 - col] ? 3'b100 : 3'b000;
                5'd3: out <= data_out[0 - col] ? 3'b100 : 3'b000;
                5'd4: out <= bg;
            endcase
        end else begin
            out <= bg;
            on <= 1'b0;
        end
    end

 endmodule