module top_module(
  input [31:0] a,
  input [31:0] b,
  input unsigned_cmp,
  output reg greater,
  output reg less,
  output reg equal
);always @(*) begin
    if (unsigned_cmp) begin
      if (a > b) begin
        greater = 1;
        less = 0;
        equal = 0;
      end else if (a < b) begin
        greater = 0;
        less = 1;
        equal = 0;
      end else begin
        greater = 0;
        less = 0;
        equal = 1;
      end
    end else begin
      if (a[31] != b[31]) begin
        if (a[31] == 1) begin
          greater = 0;
          less = 1;
          equal = 0;
        end else begin
          greater = 1;
          less = 0;
          equal = 0;
        end
      end else begin
        if (a > b) begin
          greater = 1;
          less = 0;
          equal = 0;
        end else if (a < b) begin
          greater = 0;
          less = 1;
          equal = 0;
        end else begin
          greater = 0;
          less = 0;
          equal = 1;
        end
      end
    end
  end

endmodule