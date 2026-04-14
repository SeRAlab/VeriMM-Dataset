module top_module(
    input clk,
    input rst,
    input next,
    input [31:0] seed,
    output reg [9:0] num
  );localparam SEED = 128'h843233523a613966423b622562592c62;
  
  
  reg [9:0] M_x_d, M_x_q = 1'h0;
  reg [9:0] M_y_d, M_y_q = 1'h0;
  reg [9:0] M_z_d, M_z_q = 1'h0;
  reg [9:0] M_w_d, M_w_q = 1'h0;
  
  reg [9:0] t;
  
  always @* begin
    M_w_d = M_w_q;
    M_z_d = M_z_q;
    M_y_d = M_y_q;
    M_x_d = M_x_q;
    
    num = M_w_q;
    t = M_x_q ^ (M_x_q << 2'h3);
    if (next) begin
      M_x_d = M_y_q;
      M_y_d = M_z_q;
      M_z_d = M_w_q;
      M_w_d = M_w_q ^ (M_w_q >> 3'h6) ^ t ^ (t >> 2'h3);
    end
    if (rst) begin
      M_x_d = 10'h062;
      M_y_d = 10'h225;
      M_z_d = 10'h166;
      M_w_d = 10'h352 ^ seed;
    end
  end
  
  always @(posedge clk) begin
    M_x_q <= M_x_d;
    M_y_q <= M_y_d;
    M_z_q <= M_z_d;
    M_w_q <= M_w_d;
  end
  
endmodule