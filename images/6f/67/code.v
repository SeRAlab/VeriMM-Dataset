module top_module(
  input         [31:0]  a,
  input         [31:0]  b,
  input         [1:0]   aluc,
  output reg    [31:0]  data_out,
  output reg            carry, negative, 
  output                zero, overflow
  );localparam WIDTH = 32;
    localparam MSB   = WIDTH - 1;
    reg        extra;




    assign zero = (data_out ? 1'b0 : 1'b1);

    always @(*)
        case (aluc)
            2'b00:       {carry, data_out} <= a + b;
            2'b10: begin {extra, data_out} <= {a[MSB], a} + {b[MSB], b}; negative = data_out[MSB]; end
            2'b01:       {carry, data_out} <= a - b;
            2'b11: begin {extra, data_out} <= {a[MSB], a} - {b[MSB], b}; negative = data_out[MSB]; end
        endcase

    assign overflow = extra ^ data_out[MSB];
endmodule