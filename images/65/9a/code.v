module top_module (
    input [1:0] n,
    output reg y
);

    always @(*) begin
        case (n)
            2'b00: y = 1;
            2'b01: y = 1;
            2'b10: y = 0;
            2'b11: y = 0;
            default: y = 0; // Default case
        endcase
    end
endmodule