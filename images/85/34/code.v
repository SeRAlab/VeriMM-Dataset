module top_module(clk_125, clk_25, hsync, vsync, active, rgb, tmds, 
  tmdsb, hdmi_cec, hdmi_hpd, hdmi_out_en);input clk_125;
  input clk_25;
  input hsync;
  input vsync;
  input active;
  input [23:0]rgb;
  output [3:0]tmds;
  output [3:0]tmdsb;
  input hdmi_cec;
  input hdmi_hpd;
  output hdmi_out_en;

  reg [7:0] r;
  reg [7:0] g;
  reg [7:0] b;
  reg [3:0] tmds;
  reg [3:0] tmdsb;

  assign hdmi_out_en = active;

  always @ (posedge clk_125) begin
    r <= rgb[23:16];
    g <= rgb[15:8];
    b <= rgb[7:0];

    tmds[3] <= ~(b[0] ^ g[0]);
    tmds[2] <= ~(b[1] ^ g[1]);
    tmds[1] <= ~(b[2] ^ g[2]);
    tmds[0] <= ~(b[3] ^ g[3]);

    tmdsb[3] <= tmds[3];
    tmdsb[2] <= tmds[2];
    tmdsb[1] <= tmds[1];
    tmdsb[0] <= ~tmds[0];
  end

endmodule