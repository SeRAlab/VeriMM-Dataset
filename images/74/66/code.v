module top_module(
   input  rst, clk40,
   input  [3:0] datain,
   output trig_done, 
   output trig_out
);reg [3:0] trig_sr;
reg [1:0] shift_cnt;

always @ (posedge clk40 or posedge rst) begin
   if (rst) begin
      trig_sr   <= 4'h0;
      shift_cnt <= 2'b11;
   end
   else begin
      shift_cnt <= shift_cnt + 1;
      if (shift_cnt == 2'b11) begin
         trig_sr <= datain;
      end
      else begin
         trig_sr <= {trig_sr[2:0], 1'b0};
      end
   end
end

assign trig_done = &shift_cnt;
assign trig_out  = trig_sr[3];

endmodule