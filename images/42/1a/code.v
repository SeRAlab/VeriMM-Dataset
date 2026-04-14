module mux_4to1 (
    input wire [3:0] a,
    input wire [1:0] sel,
    output reg y
);

    always @(*) begin
        case (sel)
            2'b00: y = a[0];
            2'b01: y = a[1];
            2'b10: y = a[2];
            2'b11: y = a[3];
            default: y = 1'b0;
        endcase
    end

endmodule