module top_module(rs1,rs2,isMult,isDiv,isSigned,hi_o,lo_o);input[31:0] rs1;
  input[31:0] rs2;
  input isMult;
  input isDiv;
  input isSigned;


  output[31:0] hi_o;  
  output[31:0] lo_o;
  
  reg[31:0] hi;
  reg[31:0] lo;
  
  
  assign hi_o=hi;
  assign lo_o=lo;
  
  always@(rs1 or rs2 or isMult or isDiv or isSigned)
    begin
      if(isSigned && isMult)
        {hi,lo}<=$signed(rs1)*$signed(rs2);
      if(!isSigned && isMult)
        {hi,lo}<=rs1*rs2;
      if(isSigned && isDiv)
        begin
          lo<=$signed(rs1)/$signed(rs2);
          hi<=$signed(rs1)%$signed(rs2);
        end          
      if(!isSigned && isDiv)
        begin
          lo<=rs1/rs2;
          hi<=rs1%rs2;
        end
    end
  
endmodule