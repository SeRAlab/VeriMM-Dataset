module top_module(
   inout ld,
   input clk,
   input rst,
   output reg vcap
);reg [31:0] count;
   reg [31:0] discharge_count;
   reg [31:0] charge_count;
   reg charging;
   reg discharging;

   assign ld = charging | discharging;

   always @(posedge clk) begin
      if (rst) begin
         vcap <= 0;
         count <= 0;
         discharge_count <= 0;
         charge_count <= 0;
         charging <= 0;
         discharging <= 0;
      end else begin
         if (charging) begin
            if (count == 31'd499999) begin
               count <= 0;
               charging <= 0;
               discharging <= 1;
            end else begin
               count <= count + 1;
            end
         end else if (discharging) begin
            if (vcap == 0) begin
               vcap <= 0;
               count <= 0;
               discharge_count <= 0;
               charge_count <= 0;
               charging <= 0;
               discharging <= 0;
            end else if (discharge_count == 31'd49999) begin
               discharge_count <= 0;
               vcap <= vcap - 1;
            end else begin
               discharge_count <= discharge_count + 1;
            end
         end else if (ld) begin
            vcap <= 0;
            count <= 0;
            discharge_count <= 0;
            charge_count <= 0;
            charging <= 1;
            discharging <= 0;
         end
      end
   end

endmodule