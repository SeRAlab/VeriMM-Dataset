module top_module(
    input [7:0] A,
    input [7:0] B,
    output reg [15:0] C  // Changed 'output' to 'output reg'
);integer i, j;
    reg [15:0] sum;
    
    always @(*) begin
        sum = 0;
        for (i = 0; i < 8; i = i + 1) begin
            if (B[i] == 1) begin
                for (j = 0; j < 8; j = j + 1) begin
                    if (A[j] == 1) begin
                        sum = sum + (1 << (i + j));
                    end
                end
            end
        end
        C = sum;
    end
endmodule