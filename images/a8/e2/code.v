module top_module(
    input [1:0] SEL,
    input [7:0] A,
    input [7:0] B,
    output reg [7:0] OUT  // Changed wire to reg
);wire [7:0] sum, diff, prod, quo;

    assign sum = A + B;
    assign diff = A - B;
    assign prod = A * B;
    assign quo = A / B;

    always @(*) begin
        case (SEL)
            2'b00: OUT = sum;
            2'b01: OUT = diff;
            2'b10: OUT = prod;
            2'b11: OUT = quo;
            default: OUT = 8'b0; // Added default case to avoid latches
        endcase
    end

endmodule