module top_module(input [3:0]opCode, RAddr1, RAddr2, EX_WAddr,
                           input EX_WDataSc2, EX_RFWen,
                           output reg stall);always @*
begin
  stall = 0;
  if(EX_WDataSc2 && EX_RFWen && (EX_WAddr!=0) && (RAddr1==EX_WAddr))
    case(opCode)
      
      4'd0,4'd1,4'd2,4'd3,4'd4,4'd5,4'd6,4'd7,4'd8,4'd9: stall=1;
      default: stall=0;
    endcase
  if(EX_WDataSc2 && EX_RFWen && (EX_WAddr!=0) && (RAddr2==EX_WAddr))
    case(opCode)
      
      4'd0,4'd1,4'd2,4'd3,4'd10: stall=1;
      default: stall=0;
    endcase
end

endmodule