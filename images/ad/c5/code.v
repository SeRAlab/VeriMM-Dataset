module top_module(
    input [3:0] sw,
    output reg [3:0] led
);always @ (sw) begin
    case (sw)
        4'b0000: led = 4'b0001;
        4'b0001: led = 4'b0010;
        4'b0010: led = 4'b0011;
        4'b0011: led = 4'b0100;
        4'b0100: led = 4'b0101;
        4'b0101: led = 4'b0110;
        4'b0110: led = 4'b0111;
        4'b0111: led = 4'b1000;
        4'b1000: led = 4'b1001;
        4'b1001: led = 4'b1010;
        4'b1010: led = 4'b1011;
        4'b1011: led = 4'b1100;
        4'b1100: led = 4'b1101;
        4'b1101: led = 4'b1110;
        4'b1110: led = 4'b1111;
        4'b1111: led = 4'b0000;
        default: led = 4'b0000;
    endcase
end

endmodule