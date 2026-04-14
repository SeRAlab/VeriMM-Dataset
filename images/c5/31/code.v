module decoder (
    input EN,
    input SEL,
    output reg [3:0] Y
);

always @ (EN, SEL)
begin
    if (EN)
    begin
        case (SEL)
            1'b0: Y = 4'b0001;
            1'b1: Y = 4'b0010;
        endcase
    end
    else
    begin
        Y = 4'b0000;
    end
end

endmodule