module top_module(

  

  clk,
  s422_de,
  s422_sync,
  s422_data,

  

  s444_sync,
  s444_data);parameter   Cr_Cb_N = 0;
  parameter   DELAY_DATA_WIDTH = 16;
  localparam  DW = DELAY_DATA_WIDTH - 1;

  

  input           clk;
  input           s422_de;
  input   [DW:0]  s422_sync;
  input   [15:0]  s422_data;

  

  output  [DW:0]  s444_sync;
  output  [23:0]  s444_data;

  

  reg             cr_cb_sel = 'd0;
  reg             s422_de_d = 'd0;
  reg     [DW:0]  s422_sync_d = 'd0;
  reg             s422_de_2d = 'd0;
  reg      [7:0]  s422_Y_d;
  reg      [7:0]  s422_CbCr_d;
  reg      [7:0]  s422_CbCr_2d;
  reg     [DW:0]  s444_sync = 'd0;
  reg     [23:0]  s444_data = 'd0;
  reg     [ 8:0]  s422_CbCr_avg;

  

  wire    [ 7:0]  s422_Y;
  wire    [ 7:0]  s422_CbCr;

  
  
  
  
  
  
  
  

  assign s422_Y = s422_data[7:0];
  assign s422_CbCr = s422_data[15:8];


  
  

  always @(posedge clk) begin
    if (s422_de_d == 1'b1) begin
      cr_cb_sel <= ~cr_cb_sel;
    end else begin
      cr_cb_sel <= Cr_Cb_N;
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

  
  
  always @(s422_de_2d, s422_de, s422_CbCr, s422_CbCr_2d)
  begin
		if (s422_de == 1'b1 && s422_de_2d)
			s422_CbCr_avg <= s422_CbCr + s422_CbCr_2d;
		else if (s422_de == 1'b1)
			s422_CbCr_avg <= {s422_CbCr, 1'b0};
		else
			s422_CbCr_avg <= {s422_CbCr_2d, 1'b0};
  end

  

  always @(posedge clk) begin
    s444_sync <= s422_sync_d;
    s444_data[15:8] <= s422_Y_d;
	if (cr_cb_sel) begin
		s444_data[23:16] <= s422_CbCr_d;
		s444_data[ 7: 0] <= s422_CbCr_avg[8:1];
	end else begin
		s444_data[23:16] <= s422_CbCr_avg[8:1];
		s444_data[ 7: 0] <= s422_CbCr_d;
	end
  end

endmodule