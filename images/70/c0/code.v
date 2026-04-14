module priority_encoder_5bit(
    input [4:0] in,
    output reg [2:0] out
    );

    always @ (in)
    begin
        casex (in)
            5'b1xxxx: out = 3'b100;
            5'b01xxx: out = 3'b011;
            5'b001xx: out = 3'b010;
            5'b0001x: out = 3'b001;
            5'b00001: out = 3'b000;
            default: out = 3'b000;
        endcase
    end
endmodule