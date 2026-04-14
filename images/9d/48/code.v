module top_module(
    input clk, reset,
    input [7:0] multiplier,
    input [7:0] multiplicand,
    input [7:0] adder_out,
    input [7:0] sub_out,
    output reg [15:0] product
);reg signed [15:0] temp_product;
    reg signed [3:0] temp_multiplier;
    reg signed [3:0] temp_multiplicand;
    reg signed [7:0] temp_adder_out;
    reg signed [7:0] temp_sub_out;
    
    always @(posedge clk) begin
        if (reset) begin
            product <= 0;
            temp_product <= 0;
            temp_multiplier <= 0;
            temp_multiplicand <= 0;
            temp_adder_out <= 0;
            temp_sub_out <= 0;
        end else begin
            temp_multiplier <= multiplier;
            temp_multiplicand <= multiplicand;
            temp_adder_out <= adder_out;
            temp_sub_out <= sub_out;
            
            temp_product <= {temp_multiplier, 4'b0} * {temp_multiplicand, 4'b0};
            product <= temp_product + {temp_adder_out, 8'b0} - {temp_sub_out, 8'b0};
        end
    end

endmodule