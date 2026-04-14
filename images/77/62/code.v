module top_module(CLK, RST_N, LD, UP, DN, Q, MAX, MIN);parameter WIDTH = 4;
  parameter MAX_VALUE = (1 << WIDTH) - 1;

  input CLK;
  input RST_N;
  input LD;
  input UP;
  input DN;
  output reg [WIDTH-1:0] Q;
  output MAX;
  output MIN;

  reg [WIDTH-1:0] load_value;

  always @ (posedge CLK) begin
    if (!RST_N) begin
      Q <= 0;
    end else if (LD) begin
      Q <= load_value;
    end else if (UP && !DN) begin
      if (Q == MAX_VALUE) begin
        Q <= 0;
      end else begin
        Q <= Q + 1;
      end
    end else if (DN && !UP) begin
      if (Q == 0) begin
        Q <= MAX_VALUE;
      end else begin
        Q <= Q - 1;
      end
    end
  end

  assign MAX = (Q == MAX_VALUE);
  assign MIN = (Q == 0);

  always @ (posedge CLK) begin
    if (LD) begin
      load_value <= Q;
    end
  end

endmodule