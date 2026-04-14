module top_module(
    input clk,
    input ce,
    input signed [31:0] a,
    input signed [15:0] b,
    output signed [31:0] p
);reg signed [31:0] a_reg;
reg signed [15:0] b_reg;
reg signed [31:0] product_reg;
reg [1:0] state;

assign p = (state == 2) ? product_reg : 0;

always @(posedge clk) begin
    if (ce) begin
        case (state)
            0: begin
                a_reg <= a;
                b_reg <= b;
                state <= 1;
            end
            1: begin
                product_reg <= a_reg * b_reg;
                state <= 2;
            end
            2: begin
                state <= 0;
            end
        endcase
    end
end

endmodule