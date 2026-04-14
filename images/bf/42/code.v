module decoder_2to4(
    input           a,
    input           b,
    input           en,
    output  reg     y0,
    output  reg     y1,
    output  reg     y2,
    output  reg     y3
);

always @(*) begin
    if (en) begin
        case ({a, b})
            2'b00: {y3, y2, y1, y0} = 4'b0001;
            2'b01: {y3, y2, y1, y0} = 4'b0010;
            2'b10: {y3, y2, y1, y0} = 4'b0100;
            2'b11: {y3, y2, y1, y0} = 4'b1000;
        endcase
    end else begin
        {y3, y2, y1, y0} = 4'b0000;
    end
end

endmodule