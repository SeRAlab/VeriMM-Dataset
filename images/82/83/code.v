module top_module(
    input [15:0] A,
    input [3:0] B,
    output reg [15:0] Y
);reg [15:0] stage1_out;
reg [15:0] stage2_out;
reg [15:0] stage3_out;

always @(*) begin
    if (B > 4'd15) begin // Adjust the upper condition to use a 4-bit constant
        Y = 16'b0; // Explicit zero
    end else if (B > 4'd0) begin // Changed to handle shifting only when B > 0
        // Right shift operation based on the value of B
        stage1_out = A >> B; // Logical right shift
        Y = stage1_out;
    end else begin
        // If B is zero, simply assign A to Y
        Y = A;
    end
end

endmodule