module mux_4to1(
    input wire [7:0] D0,
    input wire [7:0] D1,
    input wire [7:0] D2,
    input wire [7:0] D3,
    input wire [1:0] sel,
    output reg [7:0] Y
    );

always @(*) begin
    case (sel)
        2'b00: Y = D0;
        2'b01: Y = D1;
        2'b10: Y = D2;
        2'b11: Y = D3;
        default: Y = 8'b00000000;
    endcase
end

endmodule