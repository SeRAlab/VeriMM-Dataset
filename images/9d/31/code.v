module f_module (
    input [2:0] a,
    output reg y
);

    always @(*) begin
        case (a)
            3'b000: y = 1;
            3'b001: y = 0;
            3'b010: y = 1;
            3'b011: y = 0;
            3'b100: y = 1;
            3'b101: y = 0;
            3'b110: y = 1;
            3'b111: y = 0;
            default: y = 0; // Default case
        endcase
    end
endmodule