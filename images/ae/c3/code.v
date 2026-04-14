module top_module(
   input clk,
   input rst,
   input enable,
   output reg [3:0] out
);reg [3:0] count;
reg [3:0] next_count;

always @ (posedge clk) begin
   if (rst) begin
      count <= 4'b0;
   end else begin
      count <= next_count;
   end
end

always @ (*) begin
   if (enable) begin
      next_count = count + 4'b1;
   end else begin
      next_count = count;
   end
end

assign out = count;

endmodule