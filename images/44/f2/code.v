module top_module (
    input [1:0] k,
    output reg u
);

    always @(*) begin
        case (k)
            2'b00: u = 0;
            2'b01: u = 0;
            2'b10: u = 1;
            2'b11: u = 1;
            default: u = 0; // Default case
        endcase
    end
endmodule