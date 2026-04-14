module top_module(
  input  wire        clk,
  input  wire        reset,
  input  wire        wrenb,
  input  wire        wraddr,
  input  wire [31:0] config_data,
  input  wire        update_timers,
  input  wire        fsm_start_timer,
  input  wire        fsm_clear_timer,
  input  wire        fsm_stop_timer,
  output reg         timer_elapsed
);reg [35:0] timer, next_timer;
reg [35:0] timer_limit, next_timer_limit; // 10ns to 687 seconds
reg timer_active, next_timer_active;
reg next_timer_elapsed;

//
// 10ns resolution timer's...
//
initial 
begin 
  timer = 36'h0;
  timer_active = 1'b0;
  timer_elapsed = 1'b0;
  timer_limit = 36'h0;
end

always @ (posedge clk)
begin
  timer         <= next_timer;
  timer_active  <= next_timer_active;
  timer_elapsed <= next_timer_elapsed;
  timer_limit   <= next_timer_limit;
end

always @*
begin
  next_timer = (timer_elapsed) ? 36'h0 : timer;
  next_timer_active = timer_active;
  next_timer_elapsed = timer_elapsed;
  next_timer_limit = timer_limit;

  if (timer_active) 
    begin
      next_timer = timer+1'b1;
      if (timer >= timer_limit) 
	begin
	  next_timer_elapsed = 1'b1;
	  next_timer_active = 1'b0;
	end
    end

  if (update_timers) 
    begin
      if (fsm_start_timer) next_timer_active=1'b1;
      if (fsm_clear_timer) begin next_timer=0; next_timer_elapsed=1'b0; end
      if (fsm_stop_timer) next_timer_active=1'b0;
    end

  if (wrenb)
    case (wraddr)
      1'b0 : next_timer_limit[31:0] = config_data;
      1'b1 : next_timer_limit[35:32] = config_data[3:0];
    endcase

  if (reset)
    begin
      next_timer = 0;
      next_timer_active = 0;
      next_timer_elapsed = 0;
    end
end

always @(posedge clk)
begin
  if (timer >= timer_limit) 
    begin
      timer_elapsed <= 1'b1;
    end
  else
    begin
      timer_elapsed <= 1'b0;
    end
end

endmodule