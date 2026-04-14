module top_module(iBCD_, oSEG_);input [3:0] iBCD_; 
 output [7:0] oSEG_; 
 reg [7:0] oSEG_; 
 always @(iBCD_) 
 begin 
  case(iBCD_) 
  0:oSEG_=8'hc0; 
  1:oSEG_=8'hf9; 
  2:oSEG_=8'ha4; 
  3:oSEG_=8'hb0; 
  4:oSEG_=8'h99; 
  5:oSEG_=8'h92; 
  6:oSEG_=8'h82; 
  7:oSEG_=8'hf8; 
  8:oSEG_=8'h80; 
  9:oSEG_=8'h90; 
  10:oSEG_=8'h88; 
  11:oSEG_=8'h83; 
  12:oSEG_=8'hc6; 
  13:oSEG_=8'ha1; 
  14:oSEG_=8'h86; 
  15:oSEG_=8'hbf; 
  default:oSEG_=8'h00; 
  endcase 
 end 
 endmodule