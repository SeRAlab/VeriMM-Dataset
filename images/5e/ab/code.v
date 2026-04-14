module top_module(
  clk,
  A,
  Amax,
  out,
  CE
);parameter   A_WIDTH = 32;
  parameter   CONST_VALUE = 32'h1;
  parameter   ADD_SUB = 0;

  localparam  ADDER = 0;
  localparam  SUBSTRACTER = 1;

  

  input                     clk;
  input   [(A_WIDTH-1):0]   A;
  input   [(A_WIDTH-1):0]   Amax;
  output  [(A_WIDTH-1):0]   out;
  input                     CE;

  

  reg     [(A_WIDTH-1):0]   out = 'b0;
  reg     [A_WIDTH:0]       out_d = 'b0;
  reg     [A_WIDTH:0]       out_d2 = 'b0;
  reg     [(A_WIDTH-1):0]   A_d = 'b0;
  reg     [(A_WIDTH-1):0]   A_d2 = 'b0;
  reg     [(A_WIDTH-1):0]   Amax_d = 'b0;
  reg     [(A_WIDTH-1):0]   Amax_d2 = 'b0;

  

  reg     [(A_WIDTH-1):0]   B_reg = CONST_VALUE;

  

  always @(posedge clk) begin
      A_d <= A;
      A_d2 <= A_d;
      Amax_d <= Amax;
      Amax_d2 <= Amax_d;
  end

  

  always @(posedge clk) begin
    if ( ADD_SUB == ADDER ) begin
      out_d <= A_d + B_reg;
    end else begin
      out_d <= A_d - B_reg;
    end
  end

  

  always @(posedge clk) begin
    if ( ADD_SUB == ADDER ) begin
      if ( out_d > Amax_d2 ) begin
        out_d2 <= out_d - Amax_d2;
      end else begin
        out_d2 <= out_d;
      end
    end else begin 
      if ( out_d[A_WIDTH] == 1'b1 ) begin
        out_d2 <= Amax_d2 + out_d;
      end else begin
        out_d2 <= out_d;
      end
    end
  end

  

  always @(posedge clk) begin
    if ( CE ) begin
      out <= out_d2;
    end else begin
      out <= 'b0;
    end
  end

endmodule