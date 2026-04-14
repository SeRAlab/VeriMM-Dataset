module top_module(reset, clock, ps2c, ps2d, fifo_rd, fifo_data, fifo_empty,fifo_overflow, watchdog, count);input clock,reset,watchdog,ps2c,ps2d;
  input fifo_rd;
  output [7:0] fifo_data;
  output fifo_empty;
  output fifo_overflow;
  output [3:0] count;

  reg [3:0] count;      
  reg [9:0] shift;      

  reg [7:0] fifo[7:0];   
  reg fifo_overflow;
  reg [2:0] wptr,rptr;   

  wire [2:0] wptr_inc = wptr + 3'd1;

  assign fifo_empty = (wptr == rptr);
  assign fifo_data = fifo[rptr];

  
  reg [2:0] ps2c_sync;
  always @ (posedge clock) ps2c_sync <= {ps2c_sync[1:0],ps2c};
  wire sample = ps2c_sync[2] & ~ps2c_sync[1];

  reg timeout;
  always @(posedge clock) begin
    if(reset) begin
      count   <= 0;
      wptr    <= 0;
      rptr    <= 0;
      timeout <= 0;
      fifo_overflow <= 0;
    end else if (sample) begin
      
      if(count==10) begin
        
        if(shift[0]==0 && ps2d==1 && (^shift[9:1])==1) begin
          fifo[wptr] <= shift[8:1];
          wptr <= wptr_inc;
	  fifo_overflow <= fifo_overflow | (wptr_inc == rptr);
        end
        count <= 0;
        timeout <= 0;
      end else begin
        shift <= {ps2d,shift[9:1]};
        count <= count + 1;
      end
    end else if (watchdog && count!=0) begin
      if (timeout) begin
        
	count <= 0;
        timeout <= 0;
      end else timeout <= 1;
    end

    
    
    if (fifo_rd && !fifo_empty) begin
      rptr <= rptr + 1;
      fifo_overflow <= 0;
    end
  end

endmodule