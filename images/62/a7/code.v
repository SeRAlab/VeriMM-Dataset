module top_module(

  clk,                                           
  rstn,

  sync                                           
);localparam      PULSE_CNTR_WIDTH  = 7;
  parameter       TDD_SYNC_PERIOD   = 100000000; 

  input           clk;
  input           rstn;
  output          sync;

  

  reg     [(PULSE_CNTR_WIDTH-1):0]  pulse_counter   =  {PULSE_CNTR_WIDTH{1'b1}};
  reg     [31:0]                    sync_counter    = 32'h0;
  reg                               sync_pulse      =  1'b0;
  reg                               sync_period_eof =  1'b0;

  assign sync = sync_pulse;

  

  always @(posedge clk) begin
    if (rstn == 1'b0) begin
      sync_counter <= 32'h0;
      sync_period_eof <= 1'b0;
    end else begin
      sync_counter <= (sync_counter < TDD_SYNC_PERIOD) ? (sync_counter + 1) : 32'b0;
      sync_period_eof <= (sync_counter == (TDD_SYNC_PERIOD - 1)) ? 1'b1 : 1'b0;
    end
  end

  

  always @(posedge clk) begin
    if (rstn == 1'b0) begin
      pulse_counter <= 0;
      sync_pulse <= 0;
    end else begin
      pulse_counter <= (sync_pulse == 1'b1) ? pulse_counter + 1 : {PULSE_CNTR_WIDTH{1'h0}};
      if(sync_period_eof == 1'b1) begin
        sync_pulse <= 1'b1;
      end else if(pulse_counter == {PULSE_CNTR_WIDTH{1'b1}}) begin
        sync_pulse <= 1'b0;
      end
    end
  end

endmodule