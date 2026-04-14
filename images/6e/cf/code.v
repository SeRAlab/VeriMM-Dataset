module top_module(
        input wire x, y, z,
        input wire a, b, c, d,
        output reg o
);always @* begin
                o = a;
                if (x) o = b;
                if (y) o = c;
                if (z) o = d;
        end
endmodule