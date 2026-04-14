module top_module(
  input   wire      CLK,
  input   wire      RESETn,

  input   wire      DATA_IN,
  output  wire      DATA_OUT
);reg   stage0;
  reg   stage1;
  reg   stage2;

  always @(posedge CLK or negedge RESETn) begin
    if(~RESETn) begin
      stage0  <= 1'b0;
      stage1  <= 1'b0;
      stage2  <= 1'b0;
    end else begin
      stage0  <= DATA_IN;
      stage1  <= ~stage0;
      stage2  <= ~stage1;
    end
  end


  assign DATA_OUT   = stage2;

endmodule