module top_module(
    input wire clock,
    output reg [18:0] mem_add,
    output reg vga_hsync,
    output reg vga_vsync,
    output reg vga_sync,
    output reg vga_blank,
    output reg vga_clock
);// VGA parameters
    parameter hres = 640;
    parameter hsync = 96;
    parameter hfront = 16;
    parameter hback = 48;
    parameter htotal = hfront + hsync + hback + hres;
    parameter vres = 480;
    parameter vsync = 2;
    parameter vfront = 10;
    parameter vback = 33;
    parameter vtotal = vfront + vsync + vback + vres;

    // Internal counters
    integer hcount, vcount;

    // Initialize counters
    initial begin
        hcount = 0;
        vcount = 0;
    end

    always @(posedge clock) begin
        // Horizontal sync
        if ((hcount < (hres + hfront)) || (hcount > (hres + hfront + hsync))) begin
            vga_hsync <= 1'b1;
        end else begin
            vga_hsync <= 1'b0;
        end

        // Vertical sync
        if ((vcount < (vres + vfront)) || (vcount > (vres + vfront + vsync))) begin
            vga_vsync <= 1'b0;
        end else begin
            vga_vsync <= 1'b1;
        end

        // Sync signal
        if (vga_hsync || vga_vsync) begin
            vga_sync <= 1'b0;
        end else begin
            vga_sync <= 1'b1;
        end

        // Blanking signal
        if ((hcount <= hres) && (vcount <= vres)) begin
            mem_add <= ((vcount * hres) + hcount);
            vga_blank <= 1'b1;
        end else begin
            vga_blank <= 1'b0;
        end

        // Increment counters
        if (hcount == htotal) begin
            hcount <= 0;
            vcount <= vcount + 1;
        end

        if (vcount == vtotal - 1) begin
            hcount <= 0;
            vcount <= 0;
        end

        hcount <= hcount + 1;
        vga_clock <= ~clock;
    end

endmodule