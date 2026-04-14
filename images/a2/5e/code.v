module top_module(
  input clk, 
  input reset,
  input enable = 1,
  output reg [SIZE-1:0] count
);parameter SIZE = 32;

  always@(posedge clk) begin
    if(reset == 1) begin
      count <= 0;
    end else begin
      if(enable == 1) begin
        count <= count + 1;
      end
    end
  end

endmodule