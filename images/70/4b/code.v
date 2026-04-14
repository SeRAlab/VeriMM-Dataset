module top_module(
   input                   mux_select,

   
   input       [7:0]       tdata0,
   input                   tvalid0,
   input                   tlast0,
   output reg              tready0,
   
   input       [7:0]       tdata1,
   input                   tvalid1,
   input                   tlast1,
   output reg              tready1,
   
   
   output reg  [7:0]       tdata,
   output reg              tvalid,
   output reg              tlast,
   input                   tready
);always @(mux_select or tdata0 or tvalid0 or tlast0 or tdata1 or 
         tvalid1 or tlast1)
begin
   if (mux_select) begin
      tdata    = tdata1;
      tvalid   = tvalid1;
      tlast    = tlast1;
   end
   else begin
      tdata    = tdata0;
      tvalid   = tvalid0;
      tlast    = tlast0;
   end
end

always @(mux_select or tready)
begin
   if (mux_select) begin
      tready0     = 1'b1;
   end
   else begin
      tready0     = tready;
   end
   tready1     = tready;
end

endmodule