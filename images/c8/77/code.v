module binary_addition(
    input clk,
    input [7:0] A,
    input [7:0] B,
    output reg [7:0] C
);

    always @(posedge clk) begin
        C <= A + B;
    end

endmodule