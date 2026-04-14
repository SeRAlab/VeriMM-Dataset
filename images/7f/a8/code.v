module top_module(
    input [7:0] A,
    input [7:0] B,
    input clk, // Added clk input
    output equal,
    output A_greater_than_B,
    output A_less_than_B
);reg [7:0] A_reg, B_reg;
reg [2:0] stage;

assign equal = (A_reg == B_reg);
assign A_greater_than_B = (A_reg > B_reg);
assign A_less_than_B = (A_reg < B_reg);

always @(*) begin
    case(stage)
        0: begin
            A_reg = A;
            B_reg = B;
        end
        1: begin
            A_reg = A_reg >> 1;
            B_reg = B_reg >> 1;
        end
        2: begin
            A_reg = A_reg >> 2;
            B_reg = B_reg >> 2;
        end
        3: begin
            A_reg = A_reg >> 4;
            B_reg = B_reg >> 4;
        end
    endcase
end

always @(posedge clk) begin
    if (stage == 3) begin
        stage <= 0;
    end else begin
        stage <= stage + 1;
    end
end

endmodule