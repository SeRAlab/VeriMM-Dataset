module top_module(
    input wire  a,
    input wire  b,
    input wire  en,
    output reg y  // Changed 'wire' to 'reg' here
);always @*
    begin
      if (en)
        begin
          y = b;
        end
      else
        begin
          y = a;
        end
    end

endmodule