module top_module(
    input [31:0] A,
    input [31:0] B,
    output reg [31:0] Y  // Change output Y to reg type
);reg [63:0] P;
    integer i;

    always @(*) begin
        P = 0;  // Use blocking assignment
        for (i = 0; i < 32; i = i + 1) begin
            if (A[i] == 1) begin
                P = P + (B << i);  // Use blocking assignment
            end
        end
        Y = P[31:0];  // Use blocking assignment
    end

endmodule