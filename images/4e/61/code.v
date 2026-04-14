module top_module(clock, resetn, clear, enable, Q, D);parameter WIDTH=32; 
 parameter STAGES=1; 
 input clock,resetn,clear,enable; 
 input [WIDTH-1:0] D; 
 output [WIDTH-1:0] Q; 
 wire clock,resetn,clear,enable; 
 wire [WIDTH-1:0] D; 
 reg [WIDTH-1:0] stages[STAGES-1:0]; 
 generate 
 if (STAGES == 0) begin 
 assign Q = D; 
 end 
 else begin 
 genvar istage; 
 for (istage=0;istage<STAGES;istage=istage+1) begin : stages_loop 
 always@(posedge clock or negedge resetn) begin 
  if (!resetn) begin 
  stages[istage] <= {(WIDTH){1'b0}}; 
  end 
  else if (clear) begin 
  stages[istage] <= {(WIDTH){1'b0}}; 
  end 
  else if (enable) begin 
  if (istage == 0) begin 
  stages[istage] <= D; 
  end 
  else begin 
  stages[istage] <= stages[istage-1]; 
  end 
  end 
 end 
 end 
 assign Q = stages[STAGES-1]; 
 end 
 endgenerate 
 endmodule