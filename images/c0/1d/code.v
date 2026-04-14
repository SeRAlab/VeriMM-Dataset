module Decoder_2to4(
    input  [1:0] A,
    output reg [3:0] B
    );
    always @(A) begin
        case (A)
            2'd0 : B <= 4'b0001;
            2'd1 : B <= 4'b0010;
            2'd2 : B <= 4'b0100;
            2'd3 : B <= 4'b1000;
        endcase
    end
endmodule