module top_module(input signed [7:0] a,
                     input signed [7:0] b,
                     input [2:0] s,
                     output reg [7:0] f,
                     output reg ovf,
                     output reg take_branch);always @ (a,b,s)
        begin
          ovf = 0;
          f = 0;
          take_branch = 0;
          case (s)
            0: begin
                f = a + b;
                ovf = ((((a[7] == 0) & (b[7] == 0)) & (f[7] == 1))
                    |  (((a[7] == 1) & (b[7] == 1)) & (f[7] == 0)));
               end
            1: f = ~b;
            2: f = a & b;
            3: f = a | b;
            4: f = a >>> 1;
            5: f = a << 1;
            6: take_branch = (a == b);
            7: take_branch = (a!=b);
          endcase
        end
endmodule