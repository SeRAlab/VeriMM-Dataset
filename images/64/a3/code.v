module top_module(
  input         clka,
  input         rsta,

  input  [1:0]  diff_pair_din,
  input  [47:0] channel_din,

  output reg    request_dout, // Changed from wire to reg

  output        x_hit_dout,
  output        y_hit_dout,

  output [3:0]  x_addr_dout,
  output [3:0]  y_addr_dout,
  output [39:0] payload_dout
);reg [3:0]  x_addr_reg;
  reg [3:0]  y_addr_reg;

  reg [39:0] payload_reg;

  reg        x_hit_reg;
  reg        y_hit_reg;

  assign x_hit_dout = x_hit_reg;
  assign y_hit_dout = y_hit_reg;

  assign x_addr_dout = x_addr_reg;
  assign y_addr_dout = y_addr_reg;

  assign payload_dout = payload_reg;

  always @(posedge clka or negedge rsta) begin
    if (~rsta) begin
      x_addr_reg <= 4'b0;
      y_addr_reg <= 4'b0;
      payload_reg <= 40'b0;
      x_hit_reg <= 1'b0;
      y_hit_reg <= 1'b0;
      request_dout <= 1'b0; // Initialize request_dout
    end else begin
      case (diff_pair_din)
        2'b10: begin
          request_dout <= 1'b1;
          x_hit_reg <= 1'b0;
          y_hit_reg <= 1'b0;
          x_addr_reg <= 4'b0;
          y_addr_reg <= 4'b0;
          payload_reg <= 40'b0;
        end
        2'b01: begin
          request_dout <= 1'b0;
          if (channel_din[47:32] == 16'h0000) begin
            x_hit_reg <= 1'b1;
            y_hit_reg <= 1'b1;
            x_addr_reg <= channel_din[31:28];
            y_addr_reg <= channel_din[27:24];
          end else begin
            x_hit_reg <= 1'b0;
            y_hit_reg <= 1'b0;
            x_addr_reg <= 4'b0;
            y_addr_reg <= 4'b0;
            payload_reg <= channel_din[39:0];
          end
        end
      endcase
    end
  end

endmodule