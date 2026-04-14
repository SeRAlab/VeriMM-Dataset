module top_module(output reg gnt,input dly, done, req, clk, rst_n);parameter [1:0] IDLE = 2'b00, 
  BBUSY = 2'b01, 
  BWAIT = 2'b10, 
  BFREE = 2'b11; 
 reg [1:0] state; 
 reg [1:0] next; 
 always @(posedge clk) begin 
  state <= next; 
 end 
 always @(state or dly or done or req) begin 
  next = 2'bx; 
  gnt = 1'b0; 
  case (state) 
  IDLE: 
  if (req) 
  next = BBUSY; 
  else 
  next = IDLE; 
  BBUSY: begin 
  gnt = 1'b1; 
  if (!done) 
  next = BBUSY; 
  else begin 
  if ( dly ) 
  next = BWAIT; 
  else 
  next = BFREE; 
  end 
  end 
  BWAIT: begin 
  gnt = 1'b1; 
  if (!dly) 
  next = BFREE; 
  else begin 
  next = BWAIT; 
  end 
  end 
  BFREE: 
  if ( req ) 
  next = BBUSY; 
  else 
  next = IDLE; 
  endcase 
 end 
 endmodule