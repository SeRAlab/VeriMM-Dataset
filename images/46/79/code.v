module top_module(
    input [7:0] a,
    input [7:0] b,
    input clk,            // Added clk input
    output reg gt,       // Changed to output reg
    output reg lt,       // Changed to output reg
    output reg eq        // Changed to output reg
);reg [7:0] a_reg, b_reg;
reg [2:0] stage;

always @(posedge clk) begin
    case (stage)
        0: begin
            a_reg <= a;
            b_reg <= b;
            stage <= 1;
        end
        1: begin
            a_reg <= a_reg;
            b_reg <= b_reg;
            stage <= 2;
        end
        2: begin
            a_reg <= a_reg;
            b_reg <= b_reg;
            stage <= 3;
        end
        3: begin
            a_reg <= a_reg;
            b_reg <= b_reg;
            gt <= (a_reg > b_reg);
            lt <= (a_reg < b_reg);
            eq <= (a_reg == b_reg);
            stage <= 0;
        end
    endcase
end

endmodule