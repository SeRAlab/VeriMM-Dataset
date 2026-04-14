module top_module(
            input [31:0] first,
            input [31:0] second,
            input [3:0] control,
            output reg [31:0] out
            );always @ (*) begin
          case (control)

            4'b0000 : out <= first + second ;
            4'b0010 : out <= first - second ;
            4'b0100 : out <= first & second ;
            4'b0101 : out <= first | second ;
            4'b0110 : out <= ~(first | second) ;
            4'b0111 : out <= first ^ second ;
            4'b1000 : out <= first << second ;
            4'b1001 : out <= $signed($signed(first) >>> second) ;
            4'b1010 : out <= first >> second ;
				default : out <= 32'b0;
          endcase
        end





endmodule