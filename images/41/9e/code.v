module top_module(
                count,                  

                index,                  
                inc_dec_b,
                enable,
                rst,
                clk
                );output        count;

  input         index;       
  input         inc_dec_b;   
  input         enable;      
  input         rst;
  input         clk;
 

  
  
  

  parameter FFD       = 1;        


  
  
  
  
  
  


  
  reg           reg_cnt;
  reg           reg_extra;
  reg           reg_inc_dec_b;
  reg           reg_uflow;

  wire          cnt;
  wire          oflow;
  wire          uflow;

  always @(posedge clk or posedge rst)
  begin
    if (rst)              {reg_extra, reg_cnt} <= #FFD 2'b00;
    else if (~enable)     {reg_extra, reg_cnt} <= #FFD 2'b00;
    else if (inc_dec_b)   {reg_extra, reg_cnt} <= #FFD cnt + index;
    else                  {reg_extra, reg_cnt} <= #FFD cnt - index;
  end

  assign cnt   = oflow ? 1'b1 : (uflow ? 1'b0 : reg_cnt);

  always @(posedge clk or posedge rst)
  begin
    if (rst)  reg_inc_dec_b <= #FFD 1'b0;
    else      reg_inc_dec_b <= #FFD inc_dec_b;
  end
  assign oflow = reg_extra & reg_inc_dec_b;


  always @(posedge clk or posedge rst)
  begin
    if (rst)
      reg_uflow <= 1'b0;
    else
      reg_uflow <=  #FFD ~count & index & ~inc_dec_b;
  end
    
  assign uflow = reg_uflow;


  
  
  


  reg     reg_count;
  always @(posedge clk or posedge rst)
  begin
    if (rst)            reg_count <= #FFD 1'b0;
    else if (~enable)   reg_count <= #FFD 1'b0;
    else if (oflow)     reg_count <= #FFD 1'b1;
    else if (uflow)     reg_count <= #FFD 1'b0;
    else                reg_count <= #FFD cnt;
  end

  assign count = reg_count;


  
  
  

endmodule