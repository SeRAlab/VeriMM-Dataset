module priority_encoder(
    input [7:0] in,
    output reg [2:0] out,
    output reg valid
);

always @(*) begin
    valid = 1'b1;
    case (1'b1)
        in[7]: out = 3'b111;
        in[6]: out = 3'b110;
        in[5]: out = 3'b101;
        in[4]: out = 3'b100;
        in[3]: out = 3'b011;
        in[2]: out = 3'b010;
        in[1]: out = 3'b001;
        in[0]: out = 3'b000;
        default: begin
            out = 3'b000;
            valid = 1'b0;
        end
    endcase
end

endmodule