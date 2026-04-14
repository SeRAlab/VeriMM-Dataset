module top_module(
  input   clock,
  input   reset,
  input   [31:0] max_val,
  output  reg [31:0] count
);always @(posedge clock or posedge reset) begin
    if (reset) begin
      count <= 0;
    end
    else begin
      if (count == max_val) begin
        count <= 0;
      end
      else begin
        count <= count + 1;
      end
    end
  end
  
endmodule