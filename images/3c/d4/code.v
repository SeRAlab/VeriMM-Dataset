module mux8to1 (
    input [7:0] data,  // 8 data inputs
    input [2:0] sel,   // 3-bit select input
    output reg y       // output
);
    always @(*) begin
        case (sel)
            3'b000: y = data[0];
            3'b001: y = data[1];
            3'b010: y = data[2];
            3'b011: y = data[3];
            3'b100: y = data[4];
            3'b101: y = data[5];
            3'b110: y = data[6];
            3'b111: y = data[7];
            default: y = 1'b0; // default case
        endcase
    end
endmodule