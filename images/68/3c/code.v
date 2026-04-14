module top_module(
    input clk,
    input reset,
    input [3:0] a, b,
    output reg [7:0] product
);integer i; // Declare 'i' as an integer

    always @(posedge clk) begin
        if (reset) begin
            product <= 8'b0;
        end else begin
            product <= 8'b0; // Initialize product to 0 at the start of each cycle
            for (i = 0; i < 4; i = i + 1) begin
                if (b[i]) begin
                    product <= product + (a << i);
                end
            end
        end
    end

endmodule