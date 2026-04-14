module top_module(
    input [7:0] a,
    input [7:0] b,
    input mode,
    input clk,              // Added clk input
    output reg [7:0] result
);reg [7:0] sum_reg;
reg [7:0] diff_reg;
reg [1:0] stage;

always @(*) begin
    case(stage)
        2'b00: begin
            sum_reg = a + b;
            diff_reg = a - b;
        end
        2'b01: begin
            if (mode == 0)
                result = sum_reg;
            else
                result = diff_reg;
        end
        2'b10: begin
            result = 0;
        end
        default: begin
            result = 0; // Added default case to handle undefined states
        end
    endcase
end

always @(posedge clk) begin
    if (stage == 2'b10)
        stage <= 2'b00;
    else
        stage <= stage + 1;
end

endmodule