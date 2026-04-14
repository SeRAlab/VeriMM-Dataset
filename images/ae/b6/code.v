module top_module(command, signal_in, enable_stp, reset_stp, clk_SD, signal_out, serial_complete);input wire [39:0]command; 
  input wire signal_in, enable_stp, reset_stp, clk_SD; 
  output reg [135:0]signal_out; 
  output reg serial_complete; 
  reg [8:0]contador = 0; 
  reg responsonse_width = 0; 
  always @ ( * ) begin 
  if (command[37:32] == 12) begin 
  responsonse_width = 136; 
  end else begin 
  responsonse_width = 40; 
  end 
  end 
  always @ ( posedge clk_SD ) begin 
  if (reset_stp) begin 
  signal_out <= 0; 
  contador <= 0; 
  serial_complete <= 0; 
  end else begin 
  if (enable_stp == 1) begin 
  if (contador == responsonse_width) begin 
  serial_complete <= 1; 
  contador <= 0; 
  end else begin 
  serial_complete <= 0; 
  signal_out[(responsonse_width - 1) - contador] <= signal_in; 
  contador <= contador + 1; 
  end 
  end else begin 
  signal_out <= 0; 
  end 
  end 
  end 
 endmodule