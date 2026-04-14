module top_module(
    input clk25,
    input [3:0] r1,
    input [3:0] g1,
    input [3:0] b1,
    input h1,
    input v1,
    
    input [3:0] r2,
    input [3:0] g2,
    input [3:0] b2,
    input h2,
    input v2,
    
    output reg[3:0] vga_red,
    output reg[3:0] vga_green,
    output reg[3:0] vga_blue,
    output reg vga_hsync,
    output reg vga_vsync

    );always @ * begin
        vga_hsync = h1;
        vga_vsync = v1;
        if ( r2 >= r1 && b2 >= b1 && g2 >= g1 ) begin
            vga_red <= r2;
            vga_blue <= b2;
            vga_green <= g2;
        end else begin
            vga_red <= r1;
            vga_blue <= b1;
            vga_green <= g1;
        end
    end
    
endmodule