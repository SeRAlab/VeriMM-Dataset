module divider_2bit (
    input [1:0] A,
    input [1:0] B,
    output reg [1:0] Q,
    output reg [1:0] R
);
    always @(*) begin
        if (B == 2'b00) begin
            Q = 2'b00;
            R = 2'b00;
        end else begin
            Q = A / B;
            R = A % B;
        end
    end
endmodule