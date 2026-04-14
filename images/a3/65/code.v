module top_module(
    input a, b, c,
    input [1:0] select,
    output reg w, x, y, z
);always @(*)
begin
    case(select)
        2'b00: begin
            w = a;
            x = 0;
            y = 0;
            z = 0;
        end
        2'b01: begin
            w = 0;
            x = b;
            y = 0;
            z = 0;
        end
        2'b10: begin
            w = 0;
            x = 0;
            y = c;
            z = 0;
        end
        2'b11: begin
            w = 0;
            x = 0;
            y = 0;
            z = 1;
        end
    endcase
end

endmodule