module top_module(
  input clk,
  input set_l,
  output reg [3:0] count
);wire [3:0] din;
reg [3:0] q;  // Change wire to reg to hold the FF states

assign din = count + 4'b1;

always @(posedge clk or negedge set_l) begin
  if (!set_l) begin
    q <= 4'b0;  // Asynchronous reset to zero when set_l is low
  end else begin
    q <= din;  // Update state on clock edge
  end
end

assign count = q;  // Direct assignment of register q to count

endmodule