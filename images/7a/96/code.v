module top_module(
  input wire clk,
  input wire reset,
  input wire count,
  input wire direction,
  output reg [Size-1:0] data_o
);parameter Size = 8;
  
  always @(posedge clk) begin
    if(reset) begin
      data_o <= 0;
    end else if(count) begin
      if(direction) begin
        data_o <= data_o - 1;
      end else begin
        data_o <= data_o + 1;
      end
    end
  end
  
endmodule