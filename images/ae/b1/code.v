module top_module(
    input clk,
    input reset,
    input [7:0] MULTIPLICAND_LOW,
    input [7:0] MULTIPLICAND_HIGH,
    output reg [7:0] PRODUCT_LOW,
    output reg [7:0] PRODUCT_HIGH
);reg [7:0] multiplicand_low_reg;
reg [7:0] multiplicand_high_reg;
reg [7:0] multiplier_reg;
reg [7:0] product_low_reg;
reg [7:0] product_high_reg;
reg [3:0] stage;

always @(posedge clk) begin
    if (reset) begin
        multiplicand_low_reg <= 8'd0;
        multiplicand_high_reg <= 8'd0;
        multiplier_reg <= 8'd0;
        product_low_reg <= 8'd0;
        product_high_reg <= 8'd0;
        stage <= 4'd0;
    end else begin
        case (stage)
            4'd0: begin
                multiplicand_low_reg <= MULTIPLICAND_LOW;
                multiplicand_high_reg <= MULTIPLICAND_HIGH;
                multiplier_reg <= 8'd0;
                stage <= 4'd1;
            end
            4'd1: begin
                multiplier_reg <= {multiplicand_high_reg[7], multiplicand_high_reg};
                stage <= 4'd2;
            end
            4'd2: begin
                product_low_reg <= {product_low_reg[6:0], multiplier_reg[0]};
                multiplier_reg <= {multiplier_reg[7], multiplier_reg};
                stage <= 4'd3;
            end
            4'd3: begin
                product_low_reg <= {product_low_reg[6:0], multiplier_reg[0]};
                multiplier_reg <= {multiplier_reg[7], multiplier_reg};
                stage <= 4'd4;
            end
            4'd4: begin
                product_low_reg <= {product_low_reg[6:0], multiplier_reg[0]};
                product_high_reg <= {multiplier_reg[7], product_high_reg[7:1]};
                stage <= 4'd0;
            end
        endcase
    end
end

assign PRODUCT_LOW = product_low_reg;
assign PRODUCT_HIGH = product_high_reg;

endmodule