module top_module(result, regData1, regData2 ,Operation);output reg [31:0] result;
  
  input [31:0] regData1, regData2;
  
  input [3:0] Operation;
  always @ ( * ) begin
    case (Operation)
      
      0000: result <= regData1 + regData2;
      
      
      
      
      0010: result <= regData1+	(~(regData2)+1);
      
      0100: result <= regData1 & regData2;
      
      0101: result <= regData1 | regData2;
      
      0110: result <= ~(regData1 | regData2);
      
      0111: result <= regData1 ^ regData2;
      
      1000: result <= regData1 << regData2;
      
      1000: result <= regData1 <<< regData2;
      
      1001: result <= regData1 >> regData2;
      
      1010: result <= regData1 >>> regData2;
       default: result <= 32'd0;
    endcase
  end
endmodule