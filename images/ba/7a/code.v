module top_module(input [3:0] value);wire [3:0] array[1:0];
reg  [3:0] monitor;

assign array[0] = $unsigned(value);

always @(array[0]) begin
  monitor = array[0];
end

endmodule