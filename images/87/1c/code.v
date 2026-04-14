module priority_encoder(
    input wire [3:0] in,
    output reg [1:0] out
    );

always @(*) begin
    case (1'b1)
        in[3]: out = 2'b11;
        in[2]: out = 2'b10;
        in[1]: out = 2'b01;
        in[0]: out = 2'b00;
        default: out = 2'b00;
    endcase
end

endmodule