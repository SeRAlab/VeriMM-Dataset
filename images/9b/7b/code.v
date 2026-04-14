module top_module(
    input [3:0] D,
    input [1:0] A,
    output reg [3:0] S  // Changed 'output' to 'output reg'
);always @(*) begin
        case (A)
            2'b00: S = D;
            2'b01: S = {D[2:0], 1'b0};
            2'b10: S = {D[1:0], 2'b00};
            2'b11: S = {D[0], 3'b000};
            default: S = 4'b0000; // Optional: handle unexpected cases
        endcase
    end

endmodule