module top_module(
    hsync_in,
    hsync_out,
    pixel_in,
    pixel_out,
    vde_in,
    vde_out,
    vsync_in,
    vsync_out
    );parameter input_format = "rgb";
    parameter output_format = "rbg";
    input hsync_in;
    output hsync_out;
    input vsync_in;
    output vsync_out;
    input [23:0]pixel_in;
    output [23:0]pixel_out;
    input vde_in;
    output vde_out;

wire [23:0]pixel_rgb;
assign hsync_out = hsync_in;
assign vsync_out = vsync_in;
assign vde_out = vde_in;

if (input_format == "rgb")
assign pixel_rgb[23:0] = {pixel_in[23:16],pixel_in[15:8],pixel_in[7:0]};
else if (input_format == "rbg")
assign pixel_rgb[23:0] = {pixel_in[23:16],pixel_in[7:0],pixel_in[15:8]};

if (output_format == "rgb")
assign pixel_out[23:0] = {pixel_rgb[23:16],pixel_rgb[15:8],pixel_rgb[7:0]};
else if (output_format == "rbg")
assign pixel_out[23:0] = {pixel_rgb[23:16],pixel_rgb[7:0],pixel_rgb[15:8]};

endmodule