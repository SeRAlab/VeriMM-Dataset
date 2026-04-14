module custom_logic (
    input x,
    input y,
    input z,
    input a,
    output reg valid);

    always @(*) begin
        case ({x, y, z, a})
            4'b1010: valid = 1;
            4'b0101: valid = 0;
            4'b1111: valid = 1;
            4'b0000: valid = 0;
            4'b1001: valid = 1;
            4'b0110: valid = 0;
            4'b1101: valid = 1;
            4'b0010: valid = 1;
            4'b1011: valid = 0;
            4'b0100: valid = 1;
            default: valid = 0;
        endcase
    end
endmodule