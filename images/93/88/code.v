module top_module(
    input [3:0] in_a,
    input [3:0] in_b,
    input mode,
    output reg [3:0] out,
    output reg overflow  // Changed from wire to reg
);reg [3:0] a_reg, b_reg, sum_reg;
reg [2:0] stage;
wire [3:0] sum_wire;

assign sum_wire = (mode == 0) ? (a_reg + b_reg) : (a_reg - b_reg);

always @(*) begin
    case(stage)
        0: begin
            a_reg <= in_a;
            b_reg <= in_b;
            stage <= 1;
        end
        1: begin
            sum_reg <= sum_wire;
            stage <= 2;
        end
        2: begin
            out <= sum_reg;
            overflow <= (sum_reg > 7) || (sum_reg < 4'b1000);  // Adjusted overflow condition for 4-bit values
            stage <= 0;
        end
    endcase
end

endmodule