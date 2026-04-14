module forwarding_unit (
    input [31:0] A,
    input [31:0] B,
    input [1:0] sel,
    output reg [31:0] forward_A,
    output reg [31:0] forward_B
);
    always @(*) begin
        case (sel)
            2'b00: begin
                forward_A = A;
                forward_B = B;
            end
            2'b01: begin
                forward_A = 32'b0;
                forward_B = B;
            end
            2'b10: begin
                forward_A = A;
                forward_B = 32'b0;
            end
            2'b11: begin
                forward_A = 32'b0;
                forward_B = 32'b0;
            end
            default: begin
                forward_A = 32'b0;
                forward_B = 32'b0;
            end
        endcase
    end
endmodule