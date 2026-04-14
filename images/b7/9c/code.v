module priority_encoder (
    input [2:0] in,
    output reg [1:0] out);

always @(*) begin
    casez (in)
        3'b1??: out = 2'b10;
        3'b01?: out = 2'b01;
        3'b001: out = 2'b00;
        default: out = 2'b00;
    endcase
end

endmodule