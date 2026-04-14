module custom_logic (
    input u,
    input v,
    input w,
    input x,
    output reg trigger);

    always @(*) begin
        case ({u, v, w, x})
            4'b1110: trigger = 1;
            4'b0101: trigger = 0;
            4'b1010: trigger = 1;
            4'b0001: trigger = 1;
            4'b1101: trigger = 0;
            4'b0011: trigger = 1;
            4'b1011: trigger = 0;
            4'b0100: trigger = 1;
            4'b1111: trigger = 0;
            4'b0010: trigger = 0;
            default: trigger = 0;
        endcase
    end
endmodule