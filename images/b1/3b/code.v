module mux_4to1_case (
    input wire [1:0] sel,
    input wire d0,
    input wire d1,
    input wire d2,
    input wire d3,
    output reg y
);

    always @(*) begin
        case (sel)
            2'b00: y = d0;
            2'b01: y = d1;
            2'b10: y = d2;
            2'b11: y = d3;
            default: y = 1'b0;
        endcase
    end

endmodule