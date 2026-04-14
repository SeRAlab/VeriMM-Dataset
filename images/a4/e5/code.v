module top_module(input wire clk,input wire sw,output reg db_level,output reg db_tick);localparam N = 21; 
  localparam ZERO = 0; 
  localparam WAIT1 = 1; 
  localparam ONE = 2; 
  localparam WAIT0 = 3; 
  reg [1:0] state_reg, state_next; 
  reg [N-1:0] q_reg, q_next; 
  always @ (posedge clk) begin 
  state_reg <= state_next; 
  q_reg <= q_next; 
  end 
  always @ (state_reg, q_reg, sw, q_next) begin 
  state_next <= state_reg; 
  q_next <= q_reg; 
  db_tick <= 0; 
  case (state_reg) 
  ZERO: begin 
  db_level <= 0; 
  if (sw) begin 
  state_next <= WAIT1; 
  q_next <= ~0; 
  end 
  end 
  WAIT1: begin 
  db_level <= 0; 
  if (sw) begin 
  q_next <= q_reg - 1; 
  if (q_next == 0) begin 
  state_next <= ONE; 
  db_tick <= 1; 
  end 
  end 
  else 
  state_next <= ZERO; 
  end 
  ONE: begin 
  db_level <= 1; 
  if (!sw) begin 
  state_next <= WAIT0; 
  q_next <= ~0; 
  end 
  end 
  WAIT0: begin 
  db_level <= 1; 
  if (!sw) begin 
  q_next <= q_reg - 1; 
  if (q_next == 0) 
  state_next <= ZERO; 
  end 
  else 
  state_next <= ONE; 
  end 
  endcase 
  end 
 endmodule