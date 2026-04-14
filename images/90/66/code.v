module top_module(
  dest_clk,
  dest_resetn,
  source_data,
  dest_data
  );parameter INPUT_WIDTH      = 8;                 
parameter INPUT_MAX        = INPUT_WIDTH - 1;   

  input                dest_clk;
  input                dest_resetn;
  input  [INPUT_MAX:0] source_data;
  output [INPUT_MAX:0] dest_data;

  
  wire [INPUT_MAX:0] dest_data;
  reg  [INPUT_MAX:0] dest_data_i1;
  reg  [INPUT_MAX:0] dest_data_i2;

  always @ (posedge dest_clk or negedge dest_resetn)
  begin
  if (!dest_resetn) begin
    dest_data_i1 <= {INPUT_WIDTH{1'b0}};
    dest_data_i2 <= {INPUT_WIDTH{1'b0}};
  end else begin
    dest_data_i1 <= source_data;
    dest_data_i2 <= dest_data_i1;
  end
  end

  assign dest_data = dest_data_i2;

endmodule