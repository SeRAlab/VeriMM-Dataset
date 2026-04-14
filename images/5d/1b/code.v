module shift_register(CLK, RST, CTRL, D, Q);
input CLK, RST;
input [1:0] CTRL;
input [3:0] D;
output reg [3:0] Q;

always @(posedge CLK or posedge RST) begin
    if (RST)
        Q <= 4'b0000;
    else begin
        case (CTRL)
            2'b00: Q <= Q;               // No operation
            2'b01: Q <= D;               // Parallel load
            2'b10: Q <= {Q[2:0], 1'b0};  // Shift left
            2'b11: Q <= {1'b0, Q[3:1]};  // Shift right
            default: Q <= Q;
        endcase
    end
end

endmodule