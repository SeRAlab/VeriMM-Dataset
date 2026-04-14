module top_module(dataout, clock, reset, datain);output reg dataout;
  input clock, reset, datain;
  
  reg[2:0] cs, ns;
  
  parameter a = 3'b000;
  parameter b = 3'b001;
  parameter c = 3'b010;
  parameter d = 3'b011;
  parameter e = 3'b100;
  parameter f = 3'b101;
  
  always @(posedge clock)
  begin
    if(reset)
      cs <= a;
    else
      cs <= ns;
  end

  always @(cs, datain)
  begin
    case(cs)
    a:
      begin
        if(datain)
          ns <= b;
        else
          ns <= a;
      end
    b:
      begin
        if(datain)
          ns <= c;
        else
          ns <= b;
      end
    c:
      begin
        if(datain)
          ns <= d;
        else
          ns <= a;
      end
    d:
      begin
        if(datain)
          ns <= d;
        else
          ns <= e;
      end
    e:
      begin
        if(datain)
          ns <= b; 
        else
          ns <= a;
      end
    endcase      
  end
  
  
  always @(cs, datain)
  begin
    if ( cs == e && datain == 1 )
      dataout <= 1;
    else
      dataout <= 0;
  end    
endmodule