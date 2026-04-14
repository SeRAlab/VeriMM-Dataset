module top_module(
  
  addr,
  
  clk, rst
  );parameter aw = 8;
  
  input                 clk, rst;
  output [aw-1:0]       addr;
  reg [aw-1:0]          pc;

  always @(posedge clk or negedge rst) begin
    if ( ! rst) begin
      
    end else begin
      
      
    end
  end

endmodule