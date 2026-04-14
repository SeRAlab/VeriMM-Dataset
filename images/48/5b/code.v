module top_module(
    input clk,
    input [7:0] A,
    input [7:0] B,
    output reg [15:0] product
);reg [15:0] partial_products [0:7];
reg [7:0] shifted_B;
reg [7:0] temp_A;
reg [3:0] i, j;

always @(posedge clk) begin
    shifted_B <= {B, 8'b0};
    temp_A <= A;
    for (i = 0; i < 8; i = i + 1) begin
        for (j = 0; j < 8; j = j + 1) begin
            if (temp_A[0] == 1) begin
                partial_products[j] <= {shifted_B[j], 8'b0};
            end else begin
                partial_products[j] <= 16'b0;
            end
        end
        temp_A <= {temp_A[6:0], 2'b0};
        shifted_B <= {shifted_B[7:1], 1'b0};
    end
    product <= {partial_products[0], 16'b0} + {partial_products[1], 16'b0} + {partial_products[2], 16'b0} + {partial_products[3], 16'b0} + {partial_products[4], 16'b0} + {partial_products[5], 16'b0} + {partial_products[6], 16'b0} + {partial_products[7], 16'b0};
end

endmodule