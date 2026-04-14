module adder_subtractor(
    input clk,
    input reset,
    input add_sub,
    input [15:0] operand1,
    input [15:0] operand2,
    output reg [15:0] result
    );

    always @(posedge clk or posedge reset) begin
        if (reset)
            result <= 16'b0;
        else if (add_sub)
            result <= operand1 + operand2;
        else
            result <= operand1 - operand2;
    end
endmodule