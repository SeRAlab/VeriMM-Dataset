module top_module(
    input clk,
    input reset,
    input [255:0] rx_x,
    input [255:0] rx_y,
    output reg done,
    output reg [255:0] tx_x, // Changed from wire to reg
    output reg [255:0] tx_y   // Changed from wire to reg
);reg [255:0] sum;
    reg [256:0] carry;

    always @(posedge clk)
    begin
        if (reset)
        begin
            sum <= 256'd0;
            carry <= 257'd0;
            done <= 1'b0;
            tx_x <= 256'd0; // Initialize output
            tx_y <= 256'd0; // Initialize output
        end
        else
        begin
            // Calculate sum
            sum <= rx_x + rx_y + carry[255:0]; // Fixed the part select order
            
            // Calculate carry
            carry <= {1'b0, sum[255:0]} + {1'b0, rx_x[255:0]} + {1'b0, rx_y[255:0]};
            
            // Output sum and carry
            tx_x <= sum;
            tx_y <= carry[255:0]; // Changed range to output the correct carry bits
            
            // Set done signal
            done <= 1'b1;
        end
    end

endmodule