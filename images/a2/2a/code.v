module top_module(
    input [3:0] a,
    input [3:0] b,
    input add_sub,
    output reg [3:0] result,
    output reg overflow
);reg [3:0] sum, diff;
reg [3:0] a_reg, b_reg;
reg [1:0] stage;

always @(*) begin
    case (stage)
        0: begin
            a_reg = a;
            b_reg = b;
            stage = 1;
        end
        1: begin
            if (add_sub) begin
                sum = a_reg + b_reg;
                stage = 2;
            end
            else begin
                diff = a_reg - b_reg;
                stage = 2;
            end
        end
        2: begin
            if (add_sub) begin
                result = sum;
                stage = 3;
            end
            else begin
                result = diff;
                stage = 3;
            end
        end
        3: begin
            if (result > 7 || result < -8) begin
                overflow = 1;
            end
            else begin
                overflow = 0;
            end
            stage = 0;
        end
    endcase
end

endmodule