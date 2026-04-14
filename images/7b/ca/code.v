module top_module(
  input Xplus,
  input Xminus,
  input Yplus,
  input Yminus,
  output reg touch  // Changed output to reg type
);reg Xplus_prev, Xminus_prev, Yplus_prev, Yminus_prev;
  reg Xplus_curr, Xminus_curr, Yplus_curr, Yminus_curr;
  reg Xres, Yres;
  
  always @(Xplus, Xminus, Yplus, Yminus) begin
    Xplus_prev <= Xplus_curr;
    Xminus_prev <= Xminus_curr;
    Yplus_prev <= Yplus_curr;
    Yminus_prev <= Yminus_curr;
    
    Xplus_curr <= Xplus;
    Xminus_curr <= Xminus;
    Yplus_curr <= Yplus;
    Yminus_curr <= Yminus;
    
    Xres <= Xplus_curr ^ Xminus_curr;
    Yres <= Yplus_curr ^ Yminus_curr;
  end
  
  always @(Xres, Yres) begin
    if (Xres || Yres) begin
      touch <= 1;
    end else begin
      touch <= 0;
    end
  end
  
endmodule