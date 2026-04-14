module convolutional_encoder (
    input clk,
    input rst,
    input D,
    output reg Y1,
    output reg Y2
);
    reg M1, M2;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            M1 <= 0;
            M2 <= 0;
            Y1 <= 0;
            Y2 <= 0;
        end else begin
            Y1 <= D ^ M1; // First output
            Y2 <= D ^ M1 ^ M2; // Second output
            M2 <= M1; // Shift the memories
            M1 <= D; // New input to memory M1
        end
    end
endmodule