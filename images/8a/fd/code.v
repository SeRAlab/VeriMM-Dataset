module top_module(
    input [15:0] in,
    input [3:0] sel,
    input EN,
    output reg [3:0] out
);always @ (sel or EN or in) begin
    if (EN == 1'b0) begin
        out <= 4'b0000;
    end else begin
        case (sel)
            4'b0000: out <= in[3:0];
            4'b0001: out <= in[7:4];
            4'b0010: out <= in[11:8];
            4'b0011: out <= in[15:12];
            4'b0100: out <= in[19:16];
            4'b0101: out <= in[23:20];
            4'b0110: out <= in[27:24];
            4'b0111: out <= in[31:28];
            4'b1000: out <= in[35:32];
            4'b1001: out <= in[39:36];
            4'b1010: out <= in[43:40];
            4'b1011: out <= in[47:44];
            4'b1100: out <= in[51:48];
            4'b1101: out <= in[55:52];
            4'b1110: out <= in[59:56];
            4'b1111: out <= in[63:60];
            default: out <= 4'b0000;
        endcase
    end
end

endmodule