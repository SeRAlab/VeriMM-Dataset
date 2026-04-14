module top_module( input wire [31:0] x,
     output wire [31:0] y,
     output wire ovf);wire s;
   wire [7:0] e;
   wire [22:0] m;
   assign {s, e, m} = x;

   wire [23:0] m1;
   assign m1 = {1'b1, m};

   wire [53:0] shift_m1;
   assign shift_m1 = m1 << (e - 8'd127);

   wire [30:0] i;
   assign i = (e == 8'd126) ? 31'd1 :
              (e <= 8'd125) ? 31'd0 :
              (e >= 8'd150) ? shift_m1[53:23] : shift_m1[53:23] + {30'b0, shift_m1[22]};

   assign ovf = (e >= 8'd158);

   assign y = (s == 0) ? {s, i} : {1'b1, ~i} + 32'd1;

endmodule