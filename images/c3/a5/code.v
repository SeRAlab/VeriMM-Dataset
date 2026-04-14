module mux4to1(
    input wire [3:0] A,
    input wire [3:0] B,
    input wire [3:0] C,
    input wire [3:0] D,
    input wire [1:0] S,
    output wire [3:0] Y
);
reg [3:0] Y_reg;

always @(posedge clk) begin
    case (S)
        2'b00: Y_reg <= A;
        2'b01: Y_reg <= B;
        2'b10: Y_reg <= C;
        2'b11: Y_reg <= D;
    endcase
end

assign Y = Y_reg;

endmodule