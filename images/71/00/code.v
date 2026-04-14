module top_module(input clk, input reset,
    output reg io_in_ready, // Changed to reg
    input  io_in_valid,
    input  io_in_bits_centeroidsFinished,
    input  io_in_bits_pointsFinished,
    input [15:0] io_in_bits_centeroidIndex,
    input [63:0] io_in_bits_point_x,
    input [63:0] io_in_bits_point_y,
    input [63:0] io_in_bits_point_z,
    input [4:0] io_in_tag,
    input  io_out_ready,
    output reg io_out_valid, // Changed to reg
    output reg io_out_bits_centeroidsFinished, // Changed to reg
    output reg io_out_bits_pointsFinished, // Changed to reg
    output reg [15:0] io_out_bits_centeroidIndex, // Changed to reg
    output reg [63:0] io_out_bits_point_x, // Changed to reg
    output reg [63:0] io_out_bits_point_y, // Changed to reg
    output reg [63:0] io_out_bits_point_z, // Changed to reg
    output reg [4:0] io_out_tag // Changed to reg
  );always @(posedge clk) begin
    if (reset) begin
      io_in_ready <= 1'b0;
      io_out_valid <= 1'b0;
      io_out_bits_centeroidsFinished <= 1'b0;
      io_out_bits_pointsFinished <= 1'b0;
      io_out_bits_centeroidIndex <= 16'd0;
      io_out_bits_point_x <= 64'd0;
      io_out_bits_point_y <= 64'd0;
      io_out_bits_point_z <= 64'd0;
      io_out_tag <= 5'd0;
    end else begin
      if (io_in_valid && io_out_ready) begin
        io_in_ready <= 1'b0;
        io_out_valid <= 1'b1;
        io_out_bits_centeroidsFinished <= io_in_bits_centeroidsFinished;
        io_out_bits_pointsFinished <= io_in_bits_pointsFinished;
        io_out_bits_centeroidIndex <= io_in_bits_centeroidIndex;
        io_out_bits_point_x <= io_in_bits_point_x;
        io_out_bits_point_y <= io_in_bits_point_y;
        io_out_bits_point_z <= io_in_bits_point_z;
        io_out_tag <= io_in_tag;
      end else if (!io_in_ready) begin
        io_in_ready <= 1'b1;
      end else if (!io_out_valid) begin
        io_out_valid <= 1'b0;
      end
    end
  end

endmodule