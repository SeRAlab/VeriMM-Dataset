module top_module(
  
  input  wire       clock,
  
  input  wire       execute,
  input  wire [7:0] opcode,
  
  output reg  [3:0] wrtrigmask   = 0,
  output reg  [3:0] wrtrigval    = 0,
  output reg  [3:0] wrtrigcfg    = 0,
  output reg        wrspeed      = 0,
  output reg        wrsize       = 0,
  output reg        wrFlags      = 0,
  output reg        wrTrigSelect = 0,
  output reg        wrTrigChain  = 0,
  output reg        finish_now   = 0,
  output reg        arm_basic    = 0,
  output reg        arm_adv      = 0,
  output reg        resetCmd     = 0
);reg dly_execute;





always @(posedge clock) 
begin
  dly_execute <= execute;

  if (execute & !dly_execute) begin
    
    resetCmd      <= (opcode == 8'h00);
    arm_basic     <= (opcode == 8'h01);
    
    
    
    finish_now    <= (opcode == 8'h05);
    
    arm_adv       <= (opcode == 8'h0F);
    
    

    
    wrspeed       <= (opcode == 8'h80);
    wrsize        <= (opcode == 8'h81);
    wrFlags       <= (opcode == 8'h82);

    wrTrigSelect  <= (opcode == 8'h9E);
    wrTrigChain   <= (opcode == 8'h9F);

    wrtrigmask[0] <= (opcode == 8'hC0);
    wrtrigval [0] <= (opcode == 8'hC1);
    wrtrigcfg [0] <= (opcode == 8'hC2);
    wrtrigmask[1] <= (opcode == 8'hC4);
    wrtrigval [1] <= (opcode == 8'hC5);
    wrtrigcfg [1] <= (opcode == 8'hC6);
    wrtrigmask[2] <= (opcode == 8'hC8);
    wrtrigval [2] <= (opcode == 8'hC9);
    wrtrigcfg [2] <= (opcode == 8'hCA);
    wrtrigmask[3] <= (opcode == 8'hCC);
    wrtrigval [3] <= (opcode == 8'hCD);
    wrtrigcfg [3] <= (opcode == 8'hCE);
  end else begin
    resetCmd      <= 0;
    arm_basic     <= 0;
    finish_now    <= 0;
    arm_adv       <= 0;
    wrspeed       <= 0;
    wrsize        <= 0;
    wrFlags       <= 0;
    wrTrigSelect  <= 0;
    wrTrigChain   <= 0;
    wrtrigmask    <= 0;
    wrtrigval     <= 0;
    wrtrigcfg     <= 0;
  end
end

endmodule