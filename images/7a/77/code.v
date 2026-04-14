module top_module(
    input [3:0] binary,
    output reg [3:0] hex
);always @(*) begin
    case(binary)
        4'b0000: hex <= 4'h0;
        4'b0001: hex <= 4'h1;
        4'b0010: hex <= 4'h2;
        4'b0011: hex <= 4'h3;
        4'b0100: hex <= 4'h4;
        4'b0101: hex <= 4'h5;
        4'b0110: hex <= 4'h6;
        4'b0111: hex <= 4'h7;
        4'b1000: hex <= 4'h8;
        4'b1001: hex <= 4'h9;
        4'b1010: hex <= 4'hA;
        4'b1011: hex <= 4'hB;
        4'b1100: hex <= 4'hC;
        4'b1101: hex <= 4'hD;
        4'b1110: hex <= 4'hE;
        4'b1111: hex <= 4'hF;
    endcase
end

endmodule