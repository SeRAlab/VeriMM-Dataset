module top_module(
  input signed [7:0] input_num,
  output reg [7:0] abs_value
);always @(*) begin
    if (input_num < 0) begin
      abs_value = ~input_num + 1;
    end else begin
      abs_value = input_num;
    end
  end
  
endmodule