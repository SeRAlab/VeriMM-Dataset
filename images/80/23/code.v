module top_module(
    input [7:0] A,
    input [7:0] B,
    input [1:0] op,
    input oe,
    output reg [7:0] Y
);reg [15:0] product;
reg [15:0] quotient;

always @(*) begin
    case (op)
        2'b00: Y = A + B;
        2'b01: Y = A - B;
        2'b10: begin
            product = A * B;
            Y = product[15:8];
        end
        2'b11: begin
            if (B == 0) Y = 8'h00;
            else begin
                quotient = A / B;
                Y = quotient[15:8];
            end
        end
    endcase
end

endmodule