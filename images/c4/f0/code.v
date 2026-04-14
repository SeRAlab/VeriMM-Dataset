module flag_register
   (IN_FLAG,
    LD,
    SET,
    CLR,
    CLK,
    OUT_FLAG);
  input IN_FLAG;
  input LD;
  input SET;
  input CLR;
  input CLK;
  output OUT_FLAG;

  reg flag;

  always @(posedge CLK) begin
    if (LD) begin
      flag <= IN_FLAG;
    end else if (SET) begin
      flag <= 1;
    end else if (CLR) begin
      flag <= 0;
    end
  end

  assign OUT_FLAG = flag;

endmodule