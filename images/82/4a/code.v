module top_module(
  input clk,
  input reset,
  output reg [3:0] count
);reg [11:0] dff_array;
reg [3:0] counter;

always @(posedge clk) begin
  if (reset == 1'b0) begin
    dff_array <= 12'h5A5;
    counter <= 4'b0;
  end else begin
    dff_array <= {dff_array[10:0], 1'b0};
    counter <= counter + 1;
  end
end

assign count = counter;

endmodule