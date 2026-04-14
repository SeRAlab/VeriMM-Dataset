module top_module(input clk, input ce, input reset,
                    input [1:0] Addr,
                    input [7:0] DIN,
                    input MW,
                    input LenCtr_Clock,
                    input LinCtr_Clock,
                    input Enabled,
                    input [7:0] LenCtr_In,
                    output [3:0] Sample,
                    output IsNonZero);reg [10:0] Period, TimerCtr;
  reg [4:0] SeqPos;
  
  
  reg [6:0] LinCtrPeriod, LinCtr;
  reg LinCtrl, LinHalt;
  wire LinCtrZero = (LinCtr == 0);
  
  
  reg [7:0] LenCtr;
  wire LenCtrHalt = LinCtrl; 
  wire LenCtrZero = (LenCtr == 0);
  assign IsNonZero = !LenCtrZero;
  
  always @(posedge clk) if (reset) begin
    Period <= 0;
    TimerCtr <= 0;
    SeqPos <= 0;
    LinCtrPeriod <= 0;
    LinCtr <= 0;
    LinCtrl <= 0;
    LinHalt <= 0;
    LenCtr <= 0;
  end else if (ce) begin
    
    if (MW) begin
      case (Addr)
      0: begin
        LinCtrl <= DIN[7];
        LinCtrPeriod <= DIN[6:0];
      end
      2: begin
        Period[7:0] <= DIN;
      end
      3: begin
        Period[10:8] <= DIN[2:0];
        LenCtr <= LenCtr_In;
        LinHalt <= 1;
      end
      endcase
    end

    
    if (TimerCtr == 0) begin
      TimerCtr <= Period;
    end else begin
      TimerCtr <= TimerCtr - 1;
    end
    
    
    if (LenCtr_Clock && !LenCtrZero && !LenCtrHalt) begin
      LenCtr <= LenCtr - 1;
    end
    
    
    if (LinCtr_Clock) begin
      if (LinHalt)
        LinCtr <= LinCtrPeriod;
      else if (!LinCtrZero)
        LinCtr <= LinCtr - 1;
      if (!LinCtrl)
        LinHalt <= 0;
    end
    
    
    if (!Enabled)
      LenCtr <= 0;
      
    
    if (TimerCtr == 0 && !LenCtrZero && !LinCtrZero)
      SeqPos <= SeqPos + 1;
  end
  
  assign Sample = SeqPos[3:0] ^ {4{~SeqPos[4]}};
  
endmodule