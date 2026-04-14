module top_module(
    input [7:0] A,
    input [7:0] B,
    input [2:0] OP,
    input RESET_B,
    output reg [7:0] C
);always @(*) begin
        case (OP)
            3'b000: C = A + B;
            3'b001: C = A - B;
            3'b010: C = A & B;
            3'b011: C = A | B;
            3'b100: C = A ^ B;
            3'b101: C = A << B;
            3'b110: C = A >> B;
            3'b111: C = ~A;
        endcase
    end
    
    always @(posedge RESET_B) begin
        C <= 8'b0;
    end

endmodule