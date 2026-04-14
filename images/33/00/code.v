module mux_4to1_with_forwarding(
    input [3:0] A,
    input [3:0] B,
    input [3:0] C,
    input [3:0] D,
    input [1:0] S,
    output reg [3:0] Y,
    output reg [3:0] last_output
);

always @(*) begin
    case(S)
        2'b00: begin
            if (A == 4'b1010) Y = last_output;
            else Y = A;
        end
        2'b01: begin
            if (B == 4'b1010) Y = last_output;
            else Y = B;
        end
        2'b10: begin
            if (C == 4'b1010) Y = last_output;
            else Y = C;
        end
        2'b11: begin
            if (D == 4'b1010) Y = last_output;
            else Y = D;
        end
    endcase
    last_output = Y; // Update last output for forwarding purpose
end

endmodule