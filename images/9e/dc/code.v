module priority_encoder_4bit (
    input [3:0] in,
    output reg [1:0] out,
    output reg valid
);

always @(*) begin
    valid = 1'b1;
    case (1'b1)
        in[3]: out = 2'b11;
        in[2]: out = 2'b10;
        in[1]: out = 2'b01;
        in[0]: out = 2'b00;
        default: begin
            out = 2'b00;
            valid = 1'b0;
        end
    endcase
end

endmodule