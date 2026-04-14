module top_module(
                cpl_num,               
                inc_dec_b,

                cmm_err_tlp_posted,    
                decr_cpl,
                rst,
                clk
                );output  [2:0] cpl_num;
  output        inc_dec_b;             

  input         cmm_err_tlp_posted;
  input         decr_cpl;
  input         rst;
  input         clk;
 

  
  
  

  parameter FFD       = 1;        


  
  
  


  reg     [2:0] mod_to_incr;
  reg           mod_add_sub_b;


  always @(cmm_err_tlp_posted or decr_cpl)
  begin
    case ({cmm_err_tlp_posted, decr_cpl})   
    2'b00:   begin   mod_to_incr   = 3'b000;
                     mod_add_sub_b = 1'b1;
             end
    2'b01:   begin   mod_to_incr   = 3'b001;
                     mod_add_sub_b = 1'b0;
             end
    2'b10:   begin   mod_to_incr   = 3'b001;
                     mod_add_sub_b = 1'b1;
             end
    2'b11:   begin   mod_to_incr   = 3'b000;
                     mod_add_sub_b = 1'b1;
             end
    default: begin   mod_to_incr   = 3'b000;
                     mod_add_sub_b = 1'b1;
             end
    endcase
  end


  
  
  


  reg     [2:0] reg_cpl_num;
  reg           reg_inc_dec_b;

  always @(posedge clk or posedge rst)
  begin
    if (rst)
    begin
      reg_cpl_num   <= #FFD 3'b000;
      reg_inc_dec_b <= #FFD 1'b0;
    end
    else
    begin
      reg_cpl_num   <= #FFD mod_to_incr;
      reg_inc_dec_b <= #FFD mod_add_sub_b;
    end
  end

  assign cpl_num   = reg_cpl_num;
  assign inc_dec_b = reg_inc_dec_b;


  
  
  

endmodule