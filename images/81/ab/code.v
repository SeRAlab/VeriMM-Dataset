module mux4to1 (
    input [1:0] sel,
    input [3:0] data,
    output reg y
);

    always @(*) begin
        case (sel)
            2'b00: y = data[0];
            2'b01: y = data[1];
            2'b10: y = data[2];
            2'b11: y = data[3];
            default: y = 1'b0;
        endcase
    end
endmodule