module top_module(
  input clk,
  input signed [24:0] data_1,
  input signed [24:0] data_2,
  input signed [24:0] data_3,
  input signed [24:0] data_4,
  output reg [7:0] data_p,
  input [15:0] ddata_in,
  output reg [15:0] ddata_out  // Changed to reg type
);parameter DELAY_DATA_WIDTH = 16;
  parameter DW = DELAY_DATA_WIDTH - 1;

  reg [DW:0] p1_ddata = 'd0;
  reg signed [24:0] p1_data_1 = 'd0;
  reg signed [24:0] p1_data_2 = 'd0;
  reg signed [24:0] p1_data_3 = 'd0;
  reg signed [24:0] p1_data_4 = 'd0;
  reg [DW:0] p2_ddata = 'd0;
  reg signed [24:0] p2_data_0 = 'd0;
  reg signed [24:0] p2_data_1 = 'd0;
  reg [DW:0] p3_ddata = 'd0;
  reg signed [24:0] p3_data = 'd0;

  // Changed to reg type for p1_data_x signals
  always @(posedge clk) begin
    p1_ddata <= ddata_in;
    p1_data_1 <= (data_1[24] == 1'b1) ? (~{data_1[23:0]} + 1'b1) : {data_1[23:0], 1'b0};
    p1_data_2 <= (data_2[24] == 1'b1) ? (~{data_2[23:0]} + 1'b1) : {data_2[23:0], 1'b0};
    p1_data_3 <= (data_3[24] == 1'b1) ? (~{data_3[23:0]} + 1'b1) : {data_3[23:0], 1'b0};
    p1_data_4 <= (data_4[24] == 1'b1) ? (~{data_4[23:0]} + 1'b1) : {data_4[23:0], 1'b0};
  end

  always @(posedge clk) begin
    p2_ddata <= p1_ddata;
    p2_data_0 <= p1_data_1 + p1_data_2;
    p2_data_1 <= p1_data_3 + p1_data_4;
  end

  always @(posedge clk) begin
    p3_ddata <= p2_ddata;
    p3_data <= p2_data_0 + p2_data_1;
  end

  always @(posedge clk) begin
    if (p3_data < 0) begin
      data_p <= 8'h00;
    end else if (p3_data > 255) begin
      data_p <= 8'hff;
    end else begin
      data_p <= p3_data[7:0];  // Fixed bit slicing here to correctly map to data_p
    end
    ddata_out <= p3_ddata;  // ddata_out can now be assigned as a reg
  end

endmodule