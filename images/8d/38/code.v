module top_module(
    input [3:0] A,
    input [3:0] B,
    input clk,                // Added clk as an input
    output EQ,
    output GT,
    output LT
);reg [3:0] A_reg, B_reg;
reg [2:0] stage;
wire [3:0] A_next, B_next;
wire EQ_next, GT_next, LT_next;

assign EQ = (stage == 2) ? EQ_next : 1'b0;
assign GT = (stage == 2) ? GT_next : 1'b0;
assign LT = (stage == 2) ? LT_next : 1'b0;

always @(posedge clk) begin
    case(stage)
        0: begin
            A_reg <= A;
            B_reg <= B;
            stage <= 1;
        end
        1: begin
            A_reg <= A_next;
            B_reg <= B_next;
            stage <= 2;
        end
        2: begin
            stage <= 0;
        end
    endcase
end

assign A_next = (A_reg > B_reg) ? A_reg : B_reg;
assign B_next = (A_reg > B_reg) ? B_reg : A_reg;
assign EQ_next = (A_next == B_next) ? 1'b1 : 1'b0;
assign GT_next = (A_next > B_next) ? 1'b1 : 1'b0;
assign LT_next = (A_next < B_next) ? 1'b1 : 1'b0;

endmodule