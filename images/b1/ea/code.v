module top_module(CLK, RST, IN);input CLK, RST, IN;
  reg reg1, reg2, reg3, reg4;
  wire in1;

  always @(posedge CLK or negedge RST) begin
    if(RST == 0) begin
      reg1 <= 0;
    end else begin
      reg1 <= IN;
    end
  end

  always @(posedge CLK or negedge RST) begin
    if(RST == 0) begin
      reg2 <= 0;
    end else begin
      reg2 <= 1;
    end
  end

  assign in1 = IN;

  always @(posedge CLK or negedge RST) begin
    if(RST == 0) begin
      reg3 <= 0;
    end else begin
      reg3 <= in1;
    end
  end

  always @(posedge CLK or negedge RST) begin
    if(RST == 0) begin
      reg4 <= 1;
    end else begin
      if(in1 == 1) begin
        reg4 <= ~reg4;
      end
    end
  end

endmodule