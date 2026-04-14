module top_module(input Xin,input Yin,input BorrowIn,output Diff,output BorrowOut);assign Diff = Xin ^ Yin ^ BorrowIn; 
  assign BorrowOut = (~Xin & Yin) | (~Xin & BorrowIn) | (Yin & BorrowIn); 
 endmodule