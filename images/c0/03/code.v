module cop_count #(parameter COUNT_SIZE = 16)
  (
  output reg [COUNT_SIZE-1:0] cop_counter,   
  output reg [COUNT_SIZE-1:0] cop_capture,   
  output reg                  cop_rst_o,     
  output reg                  cop_irq_o,     
  output reg                  cop_event,     
  input                       async_rst_b,   
  input                       sync_reset,    
  input                       por_reset_i,   
  input                       startup_osc_i, 
  input                       bus_clk,       
  input                       reload_count,  
  input                       clear_event,   
  input                       debug_mode_i,  
  input                       debug_ena,     
  input                       wait_ena,      
  input                       wait_mode_i,   
  input                       stop_ena,      
  input                       stop_mode_i,   
  input                       cop_ena,       
  input                [ 1:0] cop_irq_en,    
  input      [COUNT_SIZE-1:0] timeout_value, 
  input                       scantestmode   
  );
  wire stop_counter;    
  wire cop_clk;         
  wire event_reset;     
  wire cop_clk_posedge; 
  reg  cop_irq_dec;     
  reg  cop_irq;         
  reg  reload_1;        
  reg  reload_2;        
  reg  cop_clk_resync1; 
  reg  cop_clk_resync2; 
  assign event_reset = reload_count || clear_event;
  assign stop_counter = (debug_mode_i && debug_ena) ||
		        (wait_mode_i && wait_ena) || (stop_mode_i && stop_ena);
  assign cop_clk = scantestmode ? bus_clk : startup_osc_i;
  assign cop_clk_posedge = cop_clk_resync1 && !cop_clk_resync2;
  always @(posedge cop_clk or negedge async_rst_b)
    if ( !async_rst_b )
      cop_counter  <= {COUNT_SIZE{1'b1}};
    else if ( reload_2 )
      cop_counter  <= timeout_value;
    else if ( !stop_counter )
      cop_counter  <= cop_counter - 1;
  always @(posedge cop_clk or negedge por_reset_i)
    if ( !por_reset_i )
      cop_rst_o <= 1'b0;
    else if ( reload_2 )
      cop_rst_o <= 1'b0;
    else
      cop_rst_o <= (cop_counter == 0);
  always @(posedge bus_clk or negedge async_rst_b)
    if ( !async_rst_b )
      begin
        cop_clk_resync1 <= 1'b0;
        cop_clk_resync2 <= 1'b0;
	cop_capture     <= {COUNT_SIZE{1'b1}};
      end
    else if (sync_reset)
      begin
        cop_clk_resync1 <= 1'b0;
        cop_clk_resync2 <= 1'b0;
	cop_capture     <= {COUNT_SIZE{1'b1}};
      end
    else
      begin
        cop_clk_resync1 <= cop_clk;
        cop_clk_resync2 <= cop_clk_resync1;
	cop_capture     <= cop_clk_posedge ? cop_counter : cop_capture;
      end
  always @(posedge bus_clk or negedge async_rst_b)
    if ( !async_rst_b )
      reload_1 <= 1'b0;
    else if (sync_reset)
      reload_1 <= 1'b0;
    else
      reload_1 <= (sync_reset || reload_count || !cop_ena) || (reload_1 && !reload_2);
  always @(posedge cop_clk or negedge por_reset_i)
    if ( !por_reset_i )
      reload_2 <= 1'b1;
    else
      reload_2 <= reload_1;
  always @*
    case (cop_irq_en) 
       2'b01 : cop_irq_dec = (cop_counter <= 16);
       2'b10 : cop_irq_dec = (cop_counter <= 32);
       2'b11 : cop_irq_dec = (cop_counter <= 64);
       default: cop_irq_dec = 1'b0;
    endcase
  always @(posedge bus_clk or negedge async_rst_b)
    if ( !async_rst_b )
      begin
        cop_irq   <= 0;
        cop_irq_o <= 0;
      end
    else if (sync_reset)
      begin
        cop_irq   <= 0;
        cop_irq_o <= 0;
      end
    else
      begin
        cop_irq   <= cop_irq_dec;
        cop_irq_o <= cop_irq;
      end
  always @(posedge bus_clk or negedge por_reset_i)
    if ( !por_reset_i )
      cop_event <= 0;
    else
      cop_event <= cop_rst_o || (cop_event && !event_reset);
endmodule