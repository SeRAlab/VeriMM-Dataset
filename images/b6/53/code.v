module top_module(
    input [3:0] A,
    input [3:0] B,
    input [2:0] op,
    input clk,               // Added clk input
    output reg [3:0] result,
    output reg valid
);reg [3:0] a_reg;
reg [3:0] b_reg;
reg [3:0] result_reg;
reg valid_reg;

always @(posedge clk) begin
    a_reg <= A;
    b_reg <= B;
    valid_reg <= 1'b0;
    
    case(op)
        3'b000: result_reg <= a_reg + b_reg;
        3'b001: result_reg <= a_reg - b_reg;
        3'b010: result_reg <= a_reg & b_reg;
        3'b011: result_reg <= a_reg | b_reg;
        3'b100: result_reg <= a_reg ^ b_reg;
        default: result_reg <= 4'b0;
    endcase
    
    valid_reg <= 1'b1;
end

assign result = result_reg;
assign valid = valid_reg;

endmodule