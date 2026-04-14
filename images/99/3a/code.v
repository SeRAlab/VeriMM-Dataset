module top_module( ewreg,em2reg,ewmem,ealu,eb,ern,clock,resetn,
                mwreg,mm2reg,mwmem,malu,mb,mrn);input ewreg, em2reg, ewmem, clock, resetn;
    input [4:0] ern;
    input [31:0] ealu, eb;
    wire ewreg, em2reg, ewmem, clock, resetn;
    wire [4:0] ern;
    wire [31:0] ealu, eb;

    output mwreg, mm2reg, mwmem;
    output [4:0] mrn;
    output [31:0] mb, malu;
    reg mwreg, mm2reg, mwmem;
    reg [4:0] mrn;
    reg [31:0] mb, malu;

   always @ (negedge resetn or posedge clock)
      if (resetn == 0) 
         begin
            malu       <= 32'b0;
            mb         <= 32'b0;
            mrn        <=  5'b0;
            mwreg      <=  1'b0;
            mm2reg     <=  1'b0;
            mwmem      <=  1'b0;
         end 
      else
         begin 
            malu       <= ealu;
            mb         <= eb;
            mrn        <= ern;
            mwreg      <= ewreg;
            mm2reg     <= em2reg;
            mwmem      <= ewmem;
         end

endmodule