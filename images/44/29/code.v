module top_module(CLK,RST_N,ENQ,DEQ,FULL_N,EMPTY_N,D_IN,D_OUT,CLR);parameter  width   = 128;
  parameter  l2depth = 5;
  localparam depth   = 2**l2depth;

  input             CLK;
  input             RST_N;
  input             CLR;
  input             ENQ;
  input             DEQ;
  output            FULL_N;
  output            EMPTY_N;
  input[width-1:0]  D_IN;
  output[width-1:0] D_OUT;

  reg[l2depth-1:0]  pos;             
  reg[width-1:0]    dat[depth-1:0];  
  reg               empty, full;

  integer i;

  
  
  
  always@(posedge CLK) begin
    if (ENQ) begin
      for(i=depth-1;i>0;i=i-1) dat[i] <= dat[i-1];
      dat[0] <= D_IN;
    end
  end

  always@(posedge CLK) begin
    if(!RST_N || CLR) begin
      pos     <= 1'b0;
      empty   <= 1'b1;
      full    <= 1'b0;
    end else begin
      if (!ENQ &&  DEQ) pos <= pos - 1;
      if ( ENQ && !DEQ) pos <= pos + 1;
      empty <= ((pos==0         && !ENQ) || (pos==1         && (DEQ&&!ENQ)));
      full  <= ((pos==(depth-1) && !DEQ) || (pos==(depth-2) && (ENQ&&!DEQ)));
    end
  end

  assign FULL_N  = !full;
  assign EMPTY_N = !empty;
  assign D_OUT   = dat[pos-1];

endmodule