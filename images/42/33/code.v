module top_module(
    input [7:0] A,
    input [7:0] B,
    input sel,
    input clk,  // Added clk input
    output reg [15:0] out
);reg [7:0] A_reg;
reg [7:0] B_reg;
reg [15:0] product_reg;
reg signed [15:0] signed_product_reg;
reg [3:0] stage;

always @(posedge clk) begin
    case(stage)
        0: begin
            A_reg <= A;
            B_reg <= B;
            stage <= 1;
        end
        1: begin
            product_reg <= A_reg * B_reg;
            signed_product_reg <= $signed(product_reg);
            stage <= 2;
        end
        2: begin
            if(sel == 0)
                out <= product_reg;
            else
                out <= signed_product_reg;
            stage <= 0;
        end
    endcase
end

endmodule