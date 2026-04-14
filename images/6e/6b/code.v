module mux_4to1 (D, S, EN, Y);
input [3:0] D;
input [1:0] S;
input EN;
output reg Y;

always @(*) begin
    if (EN) begin
        case (S)
            2'b00: Y = D[0];
            2'b01: Y = D[1];
            2'b10: Y = D[2];
            2'b11: Y = D[3];
            default: Y = 1'b0;
        endcase
    end
    else begin
        Y = 1'b0;
    end
end

endmodule