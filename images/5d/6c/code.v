module top_module(
    input clk,
    input reset,
    input [3:0] A,
    input [3:0] B,
    output reg Y
);// 4-bit magnitude comparator module
    wire [2:0] cmp_out = A > B ? 3'b001 : A < B ? 3'b010 : 3'b100;

    // 4-to-1 multiplexer module
    reg [3:0] C = 4'b0000;
    reg [3:0] D = 4'b1111;

    always @(posedge clk, negedge reset) begin
        if (reset == 0) begin
            Y <= A;
        end else begin
            case (cmp_out)
                3'b001: Y <= C;
                3'b010: Y <= D;
                3'b100: Y <= A;
            endcase
        end
    end

endmodule