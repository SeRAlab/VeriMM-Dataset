module mux8to1 (
    input [7:0] data,
    input [2:0] sel,
    output reg out
);
    always @(*) begin
        case (sel)
            3'b000: out = data[0];
            3'b001: out = data[1];
            3'b010: out = data[2];
            3'b011: out = data[3];
            3'b100: out = data[4];
            3'b101: out = data[5];
            3'b110: out = data[6];
            3'b111: out = data[7];
            default: out = 1'b0; // Default case for safety
        endcase
    end
endmodule