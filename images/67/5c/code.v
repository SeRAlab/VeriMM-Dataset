module top_module(
    input [3:0] A,
    input [3:0] B,
    input clk,      // Added clk input
    output reg LT   // Changed LT to reg to allow assignment in always block
);reg [3:0] A_reg, B_reg;
reg [2:0] stage;

always @(posedge clk) begin
    case(stage)
        0: begin
            A_reg <= A;
            B_reg <= B;
            stage <= 1;
        end
        1: begin
            if(A_reg < B_reg)
                LT <= 1'b1;
            else
                LT <= 1'b0;
            stage <= 0;
        end
    endcase
end

endmodule