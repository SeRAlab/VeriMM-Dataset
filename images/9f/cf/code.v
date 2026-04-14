module top_module(
    input clk,                       // Added clk input
    input signed [3:0] A,
    input signed [3:0] B,
    output reg GTE
);reg signed [3:0] A_reg, B_reg;
reg [1:0] stage;

always @(posedge clk) begin
    case(stage)
        0: begin
            A_reg <= A;
            B_reg <= B;
            stage <= 1;
        end
        1: begin
            if (A_reg >= B_reg)
                GTE <= 1;
            else
                GTE <= 0;
            stage <= 0;
        end
    endcase
end

endmodule