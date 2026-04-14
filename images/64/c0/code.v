module top_module(
  input clk,
  input signed [24:0] data_1,
  input signed [24:0] data_2,
  input signed [24:0] data_3,
  input signed [24:0] data_4,
  output reg [7:0] data_p,
  input [15:0] ddata_in,
  output reg [15:0] ddata_out
);// pipeline stage 1
  reg signed [15:0] p1_data_1;
  reg signed [15:0] p1_data_2;
  reg signed [15:0] p1_data_3;
  reg signed [15:0] p1_data_4;

  always @(posedge clk) begin
    p1_data_1 <= {1'b0, data_1[23:0]};
    p1_data_2 <= {1'b0, data_2[23:0]};
    p1_data_3 <= {1'b0, data_3[23:0]};
    p1_data_4 <= {1'b0, data_4[23:0]};
  end

  // pipeline stage 2
  reg signed [16:0] p2_data_0;
  reg signed [16:0] p2_data_1;

  always @(posedge clk) begin
    p2_data_0 <= p1_data_1 + p1_data_2;
    p2_data_1 <= p1_data_3 + p1_data_4;
  end

  // pipeline stage 3
  reg signed [17:0] p3_data;

  always @(posedge clk) begin
    p3_data <= p2_data_0 + p2_data_1;
  end

  // saturation and conversion to unsigned 8-bit
  always @(posedge clk) begin
    if (p3_data > 8'h7f) begin
      data_p <= 8'hff;
    end else if (p3_data < -8'h80) begin
      data_p <= 8'h00;
    end else begin
      data_p <= p3_data[15:8];
    end
    ddata_out <= ddata_in;
  end

endmodule