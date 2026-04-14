module top_module(
    input [3:0] vin,
    output reg vout
);always @ (vin) begin
        case (vin)
            4'b0000: vout = 0;
            4'b0001: vout = 0.3333;
            4'b0010: vout = 0.6667;
            4'b0011: vout = 1;
            4'b0100: vout = 1.3333;
            4'b0101: vout = 1.6667;
            4'b0110: vout = 2;
            4'b0111: vout = 2.3333;
            4'b1000: vout = 2.6667;
            4'b1001: vout = 3;
            4'b1010: vout = 3.3333;
            4'b1011: vout = 3.6667;
            4'b1100: vout = 4;
            4'b1101: vout = 4.3333;
            4'b1110: vout = 4.6667;
            4'b1111: vout = 5;
            default: vout = 0;
        endcase
    end

endmodule