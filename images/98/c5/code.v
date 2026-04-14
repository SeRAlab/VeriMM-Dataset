module pri_enc3(
    input [2:0] in,
    output reg [1:0] out,
    output reg valid
);

always @(*) begin
    valid = 1'b1;
    casez(in)
        3'b1??: out = 2'b10;
        3'b01?: out = 2'b01;
        3'b001: out = 2'b00;
        default: begin
            out = 2'b00;
            valid = 1'b0;
        end
    endcase
end

endmodule