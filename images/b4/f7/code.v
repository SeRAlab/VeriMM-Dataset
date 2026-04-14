module top_module(
    input [3:0] a,
    input [3:0] b,
    input clk,
    output reg eq,
    output reg gt
);reg [3:0] a_reg, b_reg;
reg [1:0] stage;

always @(posedge clk) begin
    case(stage)
        2'b00: begin
            a_reg <= a;
            b_reg <= b;
            stage <= 2'b01;
        end
        2'b01: begin
            if(a_reg > b_reg) begin
                gt <= 1;
                eq <= 0;
            end else if(a_reg == b_reg) begin
                gt <= 0;
                eq <= 1;
            end else begin
                gt <= 0;
                eq <= 0;
            end
            stage <= 2'b00;
        end
    endcase
end

endmodule