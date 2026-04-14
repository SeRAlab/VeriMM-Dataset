module conv3x3 (
    input clk,
    input rst,
    input [8:0] image, // Flattened 3x3 image
    input [8:0] kernel, // Flattened 3x3 kernel
    output reg [9:0] result // Output pixel
);
    reg [9:0] sum;
    reg [2:0] state; // State for the FSM
    parameter IDLE = 3'b000, READ_IMAGE = 3'b001, READ_KERNEL = 3'b010, COMPUTE = 3'b011, OUTPUT = 3'b100;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
            sum <= 10'b0;
            result <= 10'b0;
        end else begin
            case (state)
                IDLE: begin
                    state <= READ_IMAGE;
                end
                READ_IMAGE: begin
                    sum <= sum + image[0] * kernel[0] +
                               image[1] * kernel[1] +
                               image[2] * kernel[2] +
                               image[3] * kernel[3] +
                               image[4] * kernel[4] +
                               image[5] * kernel[5] +
                               image[6] * kernel[6] +
                               image[7] * kernel[7] +
                               image[8] * kernel[8];
                    state <= OUTPUT;
                end
                OUTPUT: begin
                    result <= sum;
                    sum <= 10'b0; // Reset sum for next operation
                    state <= IDLE;
                end
            endcase
        end
    end
endmodule