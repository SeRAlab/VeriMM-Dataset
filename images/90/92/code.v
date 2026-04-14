module top_module(
    input [7:0] A,
    input [7:0] B,
    output reg [15:0] Y
);reg [15:0] temp;

integer i;

always @(*) begin
    temp = 16'b0;
    for (i = 0; i < 8; i = i + 1) begin
        if (A[i]) begin
            temp = temp + (B << i);
        end
    end
    Y = temp;
end

endmodule