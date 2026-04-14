module top_module(
    input logic[3:0] addr,
    output logic[7:0] data
);always_comb begin
    case (addr)
        4'b0000: data = 8'b0110_0000;
        4'b0001: data = 8'b1001_0000;
        4'b0010: data = 8'b0011_1101;
        4'b0011: data = 8'b0000_0001;
        4'b0100: data = 8'b1110_0011;
        4'b0101: data = 8'b0101_0001;
        4'b0110: data = 8'b1110_0001;
        4'b0111: data = 8'b1011_0000;
        4'b1000: data = 8'b1011_1111;
        4'b1001: data = 8'b1111_0111;
        default: data = 8'b0000_0000;
    endcase
end
endmodule