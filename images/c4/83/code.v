module vga_split_controller (
    input [15:0] rgb_0,
    input [15:0] rgb_1,
    input clock,
    input hsync,
    output [15:0] rgb
);

wire [15:0] rgb_left;
wire [15:0] rgb_right;

// Split the input RGB signals into left and right halves
assign rgb_left = rgb_0;
assign rgb_right = rgb_1;

// Combine the left and right halves into a single RGB signal
always @ (posedge clock) begin
    if (hsync) begin
        rgb <= {rgb_left[15:8], rgb_left[7:0], rgb_right[15:8], rgb_right[7:0]};
    end
end

endmodule