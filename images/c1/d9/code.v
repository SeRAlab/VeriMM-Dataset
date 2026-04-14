module fm_3d_norm (
  i_s,
  i_e,
  i_f,
  o_b
);
    input         i_s;          
    input  [4:0]  i_e;          
    input  [16:0] i_f;          
    output [21:0] o_b;          
    wire        w_carry;       
    wire [3:0]  w_penc;        
    wire        w_c_zero;      
    wire        w_ce_zero;     
    wire [15:0] w_lshifted;    
    wire [4:0]  w_lshift_val;  
    wire [15:0] w_c_fraction;
    wire [15:0] w_c_frac;
    wire [4:0]  w_c_exp;       
    wire        w_c_sign;      
    wire [5:0]  w_incdec_out;  
    assign w_carry  = i_f[16];
    assign w_c_zero = (i_f == 17'h0);
    assign w_penc = f_prenc(i_f[15:0]);
    assign w_incdec_out = f_incdec(i_e, w_penc, w_carry);
    assign  w_lshift_val = w_penc;
    assign w_lshifted = i_f[15:0] << w_lshift_val;
    assign w_c_frac = (w_carry) ? i_f[16:1] : w_lshifted;
    assign w_c_exp = (w_c_zero|w_incdec_out[5]) ? 5'h0 : w_incdec_out[4:0];
    assign w_ce_zero = (w_c_exp == 5'h0);
    assign w_c_sign = i_s & !w_ce_zero;
    assign w_c_fraction = (w_ce_zero) ? 16'h0 : w_c_frac;
    assign o_b = {w_c_sign, w_c_exp, w_c_fraction};
function [3:0] f_prenc;
  input [15:0] mat;
  begin
    if (mat[15] == 1'b1) begin
      f_prenc = 4'h0;
    end else if (mat[14] == 1'b1) begin
      f_prenc = 4'h1;
    end else if (mat[13] == 1'b1) begin
      f_prenc = 4'h2;
    end else if (mat[12] == 1'b1) begin
      f_prenc = 4'h3;
    end else if (mat[11] == 1'b1) begin
      f_prenc = 4'h4;
    end else if (mat[10] == 1'b1) begin
      f_prenc = 4'h5;
    end else if (mat[9] == 1'b1) begin
      f_prenc = 4'h6;
    end else if (mat[8] == 1'b1) begin
      f_prenc = 4'h7;
    end else if (mat[7] == 1'b1) begin
      f_prenc = 4'h8;
    end else if (mat[6] == 1'b1) begin
      f_prenc = 4'h9;
    end else if (mat[5] == 1'b1) begin
      f_prenc = 4'ha;
    end else if (mat[4] == 1'b1) begin
      f_prenc = 4'hb;
    end else if (mat[3] == 1'b1) begin
      f_prenc = 4'hc;
    end else if (mat[2] == 1'b1) begin
      f_prenc = 4'hd;
    end else if (mat[1] == 1'b1) begin
      f_prenc = 4'he;
    end else begin
      f_prenc = 4'hf;
    end
  end
endfunction
function [5:0] f_incdec;
  input [4:0] a;
  input [3:0] b;
  input       inc;
  reg   [5:0] r_inc;
  reg   [5:0] r_dec;
  reg         r_1f_flag;
  begin
    r_1f_flag = (a == 5'h1f);
    r_inc = a + !r_1f_flag;
    r_dec = a - b;
    f_incdec = (inc) ? r_inc : r_dec;
  end
endfunction
endmodule