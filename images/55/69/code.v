module top_module(
  input clk,
  input s444_de,
  input [15:0] s444_sync,
  input [23:0] s444_data,
  input Cr_Cb_N,
  output reg [15:0] s422_sync, // Change to reg for assignment in always block
  output reg [15:0] s422_data  // Change to reg for assignment in always block
);reg [23:0] s444_data_d1 = 0;
  reg [23:0] s444_data_d2 = 0;
  reg [23:0] s444_data_d3 = 0;
  reg [7:0] cr = 0;
  reg [7:0] cb = 0;
  reg cr_cb_sel = 0;

  always @(posedge clk) begin
    s444_data_d3 <= s444_data_d2;
    s444_data_d2 <= s444_data_d1;
    s444_data_d1 <= s444_data;
  end

  always @* begin
    cr = (s444_data_d1[23:16] + s444_data_d2[23:16] + s444_data_d3[23:16] + 1) >> 2; // Use always @* for combinatorial logic
    cb = (s444_data_d1[7:0] + s444_data_d2[7:0] + s444_data_d3[7:0] + 1) >> 2; // Use always @* for combinatorial logic
  end

  always @(posedge clk) begin
    if (s444_de) begin
      if (Cr_Cb_N) begin
        s422_data <= {cr, s444_data_d2[15:8]};
      end else begin
        s422_data <= {cb, s444_data_d2[15:8]};
      end
      cr_cb_sel <= ~cr_cb_sel; // Toggle only when s444_de is high
    end
    s422_sync <= s444_sync; // This should be assigned each clock cycle.
  end

endmodule