module top_module(
  clock, disabledGroups, 
  validIn, dataIn, 
  
  validOut, dataOut);input clock;
input [3:0] disabledGroups;
input validIn;
input [31:0] dataIn;
output validOut;
output [31:0] dataOut;





reg [1:0] insel0, next_insel0;
reg [1:0] insel1, next_insel1;
reg insel2, next_insel2;

reg [31:0] dataOut, next_dataOut;
reg validOut, next_validOut;





always @ (posedge clock)
begin
  dataOut = next_dataOut;
  validOut = next_validOut;
end

always @*
begin
  #1;
  next_dataOut = dataIn;
  next_validOut = validIn;
  case (insel0[1:0])
    2'h1 : next_dataOut[7:0] = dataIn[15:8];
    2'h2 : next_dataOut[7:0] = dataIn[23:16];
    2'h3 : next_dataOut[7:0] = dataIn[31:24];
  endcase
  case (insel1[1:0])
    2'h1 : next_dataOut[15:8] = dataIn[23:16];
    2'h2 : next_dataOut[15:8] = dataIn[31:24];
  endcase
  case (insel2)
    1'b1 : next_dataOut[23:16] = dataIn[31:24];
  endcase
end


always @(posedge clock) 
begin
  insel0 = next_insel0;
  insel1 = next_insel1;
  insel2 = next_insel2;
end

always @*
begin
  #1;

  
  
  
  
  
  
  
  
  
  
  
  
  
  
  next_insel0 = 2'h0;
  next_insel1 = 2'h0;
  next_insel2 = 1'b0;
  case (disabledGroups)
    
    4'b0001 : begin next_insel2 = 1'b1; next_insel1=2'h1; next_insel0=2'h1; end
    4'b0010 : begin next_insel2 = 1'b1; next_insel1=2'h1; end
    4'b0100 : begin next_insel2 = 1'b1; end

    
    4'b0011 : begin next_insel1=2'h2; next_insel0=2'h2; end
    4'b0101 : begin next_insel1=2'h2; next_insel0=2'h1; end
    4'b1001 : begin next_insel1=2'h1; next_insel0=2'h1; end
    4'b0110 : begin next_insel1=2'h2; end
    4'b1010 : begin next_insel1=2'h1; end
    4'b1100 : begin next_insel1=2'h0; end

    
    4'b0111 : next_insel0 = 2'h3;
    4'b1011 : next_insel0 = 2'h2;
    4'b1101 : next_insel0 = 2'h1;
  endcase
end
endmodule