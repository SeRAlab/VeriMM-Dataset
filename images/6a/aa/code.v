module top_module(
    input clk,
    input reset,
    input [15:0] data_in1,
    input [15:0] data_in2,
    input enable_pipeline,
    output reg [31:0] product_out
);reg [15:0] partial_product1;
reg [15:0] partial_product2;
reg [15:0] partial_product3;
reg [15:0] partial_product4;
reg [31:0] accumulator;

always @(posedge clk) begin
    if (reset) begin
        partial_product1 <= 0;
        partial_product2 <= 0;
        partial_product3 <= 0;
        partial_product4 <= 0;
        accumulator <= 0;
        product_out <= 0;
    end else begin
        if (enable_pipeline) begin
            // Pipeline stage 1: Fetch inputs
            partial_product1 <= data_in1;
            partial_product2 <= data_in2;
            
            // Pipeline stage 2: Partial product generation
            partial_product3 <= partial_product1 * partial_product2;
            
            // Pipeline stage 3: Addition of partial products
            partial_product4 <= {partial_product3[15:0], 16'b0} + {partial_product3[31:16], 16'b0};
            
            // Pipeline stage 4: Accumulation of partial products
            accumulator <= accumulator + partial_product4;
            
            // Pipeline stage 5: Output
            product_out <= accumulator;
        end else begin
            product_out <= data_in1 * data_in2;
        end
    end
end

endmodule