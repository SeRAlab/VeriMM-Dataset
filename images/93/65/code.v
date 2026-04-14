module top_module(
    
    input                     clk_i, 
    input                     rst_i, 
    input      signed [15:0]  datal_i,
    input      signed [15:0]  datar_i,
    output reg signed [15:0]  datal_o,
    output reg signed [15:0]  datar_o,

    output reg                ready_o,



    
    input                     aud_bclk_i,
    input                     aud_daclrck_i,
    output reg                aud_dacdat_o,
    input                     aud_adcdat_i
  );reg fBCLK_HL;

  reg bCurrentClk;
  reg bFilterClk1;
  reg bFilterClk2;

  reg bDACLRCK_old;
  reg bDACLRCK;

  reg [15:0] rDAC;
  reg [15:0] rADC;

  reg fADCReady;

  
  always @(posedge clk_i or posedge rst_i)
  begin
    if (rst_i)
    begin
      fBCLK_HL <= 1'b0;

      bCurrentClk <= 1'b0;
      bFilterClk1 <= 1'b0;
      bFilterClk2 <= 1'b0;
    end
    else
    begin
      bFilterClk1 <= aud_bclk_i;
      bFilterClk2 <= bFilterClk1;
      if ((bFilterClk1 == bFilterClk2) && (bCurrentClk != bFilterClk2))
      begin
        bCurrentClk <= bFilterClk2;
        if (bCurrentClk == 1'b1)
          fBCLK_HL <= 1'b1;  


      end
      if (fBCLK_HL)
        fBCLK_HL <= 1'b0; 


    end
  end  

  
  always @(posedge clk_i)
    bDACLRCK <= aud_daclrck_i;

  
  always @(posedge clk_i)
  begin
    if (fBCLK_HL)
    begin
      bDACLRCK_old <= bDACLRCK;
      if (bDACLRCK != bDACLRCK_old)
      begin
        
        rDAC <= (bDACLRCK) ? datar_i : datal_i;
        aud_dacdat_o <= 1'b0;
        
        if (bDACLRCK)
          datal_o <= rADC;
        else
          datar_o <= rADC;
        rADC <= 16'h0001;
        fADCReady <= 1'b0;
        
        ready_o <= ~bDACLRCK;
      end
      else
      begin
        
        { aud_dacdat_o, rDAC } <= { rDAC, 1'b0 };
        
        if (!fADCReady)
          { fADCReady, rADC} <= { rADC, aud_adcdat_i };
      end
    end
    else if (ready_o)
      ready_o <= 1'b0; 
  end

endmodule