module top_module(
   input clk,
   input toggle,
   input [7:0] cyc_copy,
   output reg toggle_up
);reg [7:0] cyc_count;
   reg [7:0] cyc_copy_reg;
   reg toggle_internal;

   always @(posedge clk) begin
      toggle_internal <= toggle;
   end

   always @(posedge clk) begin
      if (toggle_internal != toggle) begin
         cyc_count <= 0;
      end else begin
         cyc_count <= cyc_count + 1;
      end
   end

   always @(posedge clk) begin
      if (cyc_count == cyc_copy_reg) begin
         toggle_up <= ~toggle_up;
         cyc_count <= 0;
         cyc_copy_reg <= cyc_copy;
      end else begin
         cyc_copy_reg <= cyc_copy;
      end
   end

endmodule