module top_module(
  input       [4:0]in0,in1,
  input       JMPmux,
  output reg  [4:0]out
  );always@(in0,in1,JMPmux)
  begin
    if(JMPmux)
      out=in1;
    else
      out=in0;
  end  
    

  endmodule