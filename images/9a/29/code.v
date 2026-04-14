module top_module(
    input clk,
    input reset,
    input signed [7:0] multiplier,
    input signed [7:0] multiplicand,
    output reg signed [15:0] product, // Changed from wire to reg
    output reg done
);reg signed [15:0] partial_product;
    reg [3:0] bit_counter;
    reg signed [15:0] sum;
    
    always @(posedge clk) begin
        if (reset) begin
            bit_counter <= 0;
            partial_product <= 0;
            sum <= 0;
            done <= 0;
            product <= 0; // Initialize product
        end else begin
            if (bit_counter < 8) begin // Changed condition to < 8
                if (bit_counter == 0) begin
                    partial_product <= multiplicand;
                end else begin
                    partial_product <= {partial_product[14:0], partial_product[15]} << 1;
                end
                
                if (multiplier[bit_counter]) begin
                    sum <= sum + partial_product;
                end
                
                bit_counter <= bit_counter + 1; // Increment bit counter
                
            end else begin
                product <= sum;
                done <= 1;
            end
        end
    end
    
endmodule