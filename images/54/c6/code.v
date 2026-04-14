module top_module(
    input [15:0] A,
    input [15:0] B,
    output reg [15:0] C
);reg [3:0] i, j, k;
reg [15:0] temp;

always @(*) begin
    for (i = 0; i < 4; i = i + 1) begin
        for (j = 0; j < 4; j = j + 1) begin
            temp = 0;
            for (k = 0; k < 4; k = k + 1) begin
                temp = temp + A[i*4+k] * B[k*4+j];
            end
            C[i*4+j] = temp;
        end
    end
end

endmodule