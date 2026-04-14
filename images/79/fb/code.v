module top_module(
  input clk,
  input s422_de,
  input [7:0] s422_sync,
  input [15:0] s422_data,
  output reg [7:0] s444_sync,
  output reg [23:0] s444_data
);reg cr_cb_sel = 0;
  reg s422_de_d = 0;
  reg [7:0] s422_sync_d = 0;
  reg s422_de_2d = 0;
  reg [7:0] s422_Y_d = 0;
  reg [7:0] s422_CbCr_d = 0;
  reg [7:0] s422_CbCr_2d = 0;
  reg [8:0] s422_CbCr_avg = 0;

  wire [7:0] s422_Y = s422_data[7:0];
  wire [7:0] s422_CbCr = s422_data[15:8];

  always @(posedge clk) begin
    s444_sync <= s422_sync_d;
  end
  
  always @(posedge clk) begin
    if (s422_de_d == 1'b1) begin
      cr_cb_sel <= ~cr_cb_sel;
    end else begin
      cr_cb_sel <= 0;
    end
  end

  always @(posedge clk) begin
    s422_de_d <= s422_de;
    s422_sync_d <= s422_sync;
    s422_de_2d <= s422_de_d;
    s422_Y_d <= s422_Y;
    s422_CbCr_d <= s422_CbCr;
    s422_CbCr_2d <= s422_CbCr_d;
  end

  always @(s422_de_2d, s422_de, s422_CbCr, s422_CbCr_2d) begin
    if (s422_de == 1'b1 && s422_de_2d) begin
      s422_CbCr_avg <= s422_CbCr + s422_CbCr_2d;
    end else if (s422_de == 1'b1) begin
      s422_CbCr_avg <= {s422_CbCr, 1'b0};
    end else begin
      s422_CbCr_avg <= {s422_CbCr_2d, 1'b0};
    end
  end

  always @(posedge clk) begin
    if (cr_cb_sel == 1) begin
      s444_data[23:16] <= s422_CbCr_d;
      s444_data[7:0] <= s422_CbCr_avg[8:1];
    end else begin
      s444_data[23:16] <= s422_CbCr_avg[8:1];
      s444_data[7:0] <= s422_CbCr_d;
    end
  end

endmodule