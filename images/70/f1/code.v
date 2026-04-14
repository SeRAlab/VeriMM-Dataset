module top_module(
  input clk,
  output reg vga_hs,
  output reg vga_vs,
  output reg [4:0] vga_r,
  output reg [5:0] vga_g,
  output reg [4:0] vga_b
);// Define constants
  localparam H_RES = 640;
  localparam V_RES = 480;
  localparam H_SYNC_PULSE = 96;
  localparam H_FRONT_PORCH = 16;
  localparam H_BACK_PORCH = 48;
  localparam V_SYNC_PULSE = 2;
  localparam V_FRONT_PORCH = 10;
  localparam V_BACK_PORCH = 33;
  localparam PIXEL_CLOCK = 25175000;

  // Define counters
  reg [9:0] h_counter = 0;
  reg [8:0] v_counter = 0;

  // Horizontal timing
  always @(posedge clk) begin
    if (h_counter >= H_RES + H_SYNC_PULSE + H_FRONT_PORCH + H_BACK_PORCH - 1) begin
      h_counter <= 0;
      v_counter <= v_counter + 1;
    end else begin
      h_counter <= h_counter + 1;
    end
  end

  // Vertical timing
  always @(posedge clk) begin
    if (v_counter >= V_RES + V_SYNC_PULSE + V_FRONT_PORCH + V_BACK_PORCH - 1) begin
      h_counter <= 0;
      v_counter <= 0;
    end
  end

  // Horizontal sync
  always @(posedge clk) begin
    if (h_counter >= H_RES + H_FRONT_PORCH && h_counter < H_RES + H_FRONT_PORCH + H_SYNC_PULSE) begin
      vga_hs <= 0;
    end else begin
      vga_hs <= 1;
    end
  end

  // Vertical sync
  always @(posedge clk) begin
    if (v_counter >= V_RES + V_FRONT_PORCH && v_counter < V_RES + V_FRONT_PORCH + V_SYNC_PULSE) begin
      vga_vs <= 0;
    end else begin
      vga_vs <= 1;
    end
  end

  // Color generation
  always @(posedge clk) begin
    if (h_counter >= H_RES + H_FRONT_PORCH && h_counter < H_RES + H_FRONT_PORCH + 8) begin
      vga_r <= 31;
      vga_g <= 63;
      vga_b <= 31;
    end else begin
      vga_r <= 0;
      vga_g <= 0;
      vga_b <= 0;
    end
  end

endmodule