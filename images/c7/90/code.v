module mux_2_1(
    input wire  a,
    input wire  b,
    input wire  en,
    output wire y
);

  always @*
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