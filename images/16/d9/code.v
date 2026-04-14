module pipeline_adder (
    input clk,
    input rst,
    input [7:0] A,
    input [7:0] B,
    input [7:0] C,
    output reg [7:0] S2
);

    reg [7:0] S1;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            S1 <= 0;
            S2 <= 0;
        end else begin
            S1 <= A + B;
            S2 <= S1 + C;
        end
    end
endmodule