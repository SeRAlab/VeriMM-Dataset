module divider_2bit (
    input [1:0] A,
    input [1:0] B,
    output reg [1:0] Q,
    output reg R
);
    
always @(*) begin
    if (B == 2'b00) begin
        Q = 2'b00; // Handle division by zero
        R = 1'b0;
    end else begin
        Q = A / B; // Compute quotient
        R = A % B; // Compute remainder
    end
end

endmodule