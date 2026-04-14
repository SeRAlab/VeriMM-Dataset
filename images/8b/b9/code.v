module top_module(
    input [31:0] A,
    input [31:0] B,
    input [1:0] Op,
    output reg [31:0] C  // Change wire to reg for output
);reg [63:0] prod;      // Change wire to reg for prod
    reg [31:0] quotient;  // Change wire to reg for quotient
    reg [31:0] remainder; // Change wire to reg for remainder

    always @* begin
        case(Op)
            2'b00: C = A + B;
            2'b01: C = A - B;
            2'b10: begin
                prod = A * B;
                C = prod[31:0];
            end
            2'b11: begin
                if(B == 0) begin
                    C = 32'hffffffff;
                end else begin
                    quotient = A / B;
                    remainder = A % B;
                    C = quotient;
                end
            end
            default: C = 32'b0; // Optional: Handle default case
        endcase
    end

endmodule