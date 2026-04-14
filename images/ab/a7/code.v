module top_module(
    input [15:0] A,
    input [15:0] B,
    output reg [15:0] C
);reg [3:0] i, j, k;
reg [15:0] sum;

always @* begin
    for(i = 0; i < 4; i = i + 1) begin
        for(j = 0; j < 4; j = j + 1) begin
            sum = 0;
            for(k = 0; k < 4; k = k + 1) begin
                sum = sum + A[i*4 + k] * B[k*4 + j];
            end
            C[i*4 + j] = sum;
        end
    end
end

endmodule