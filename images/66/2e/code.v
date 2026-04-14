module top_module( clk,      
                  en,       
                  pre_first,
                  pwm_delay,
                  pwm_cycle,
                  spread,   
                  cur_pwm,  
                  pwm_code, 
                  new_pwm,  
                  mot      
                );input         clk;      
 input         en;       
 input         pre_first;
 input   [2:0] pwm_delay;
 input   [7:0] pwm_cycle;
 input   [2:0] spread;   
 input   [2:0] cur_pwm;  
 input   [3:0] pwm_code; 
 output  [2:0] new_pwm;  
 output  [1:0] mot;      

 reg     [9:0] pwm_cycle_count; 
 reg           pwm_cycle_next;
 reg     [3:0] pwm_delay_count; 
 reg           pwm_delay_end;
 reg     [2:0] pwm_phase;
 wire    [2:0] spreaded_phase;
 wire          pwn_on; 
 wire          pwn_off; 
 wire    [2:0] new_pwm;
 wire          stop_cmd;
 wire    [3:0] pwm_diff;
 wire [1:0] mot;

 assign spreaded_phase[2:0]= pwm_phase[2:0]+spread[2:0];
 assign pwn_on= pwm_cycle_next && (spreaded_phase == 0) && (pwm_code != 0);
 assign pwn_off=pwm_cycle_next && (spreaded_phase == pwm_code[2:0]);
 assign stop_cmd= !en || (pwm_code==8) ;
 assign pwm_diff[3:0]={1'b0,pwm_code[2:0]}-{1'b0,spreaded_phase[2:0]}; 

 assign new_pwm[0]=!stop_cmd && (pwm_cycle_next? pwm_code[3] : cur_pwm[0]); 
 assign new_pwm[1]=!stop_cmd && (pwm_cycle_next?((pwm_code[2:0]!=0) && !pwm_diff[3]):cur_pwm[1]); 
 assign new_pwm[2]=!en || (pwm_cycle_next? (new_pwm[1:0]!=cur_pwm[1:0]):(cur_pwm[2]&& !pwm_delay_end));
 assign mot[1:0]=(stop_cmd || new_pwm[2])? 2'b0:(new_pwm[1]?{new_pwm[0],!new_pwm[0]}:2'b11);
 always @ (posedge clk) if (pre_first) begin 


   pwm_cycle_count<= (!en || (pwm_cycle_count==0)) ? {2'b0,pwm_cycle}:(pwm_cycle_count-1);

   pwm_cycle_next<=    en && (pwm_cycle_count==0);
   

   pwm_delay_count<= (!en || pwm_cycle_next)?{1'b0,pwm_delay}:((pwm_delay_count==0)? 4'b0: (pwm_delay_count-1));   
   pwm_delay_end<=     en && (pwm_delay_count==1);
   pwm_phase<=       (!en)? 0: (pwm_phase + pwm_cycle_next); 
 end

endmodule