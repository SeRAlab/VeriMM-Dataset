module pipeline_adder (
    input clk,
    input [3:0] A,
    input [3:0] B,
    output reg [3:0] result
);
    reg [3:0] sum;

    // First stage: Addition
    always @(posedge clk) begin
        sum <= A + B;
    end

    // Second stage: Modulo operation
    always @(posedge clk) begin
        result <= sum % 16;
    end
endmodule