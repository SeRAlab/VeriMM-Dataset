module jpeg_dct (
    input clk,
    input rst,
    input [63:0] pixel_block,  // 8x8 block of pixel values
    output reg [63:0] dct_coeffs, // DCT coefficients (8x8)
    input valid,
    output reg ready
);

    reg [2:0] state;
    parameter IDLE = 3'b000, PROCESS = 3'b001, OUTPUT = 3'b010;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
            ready <= 1;
            dct_coeffs <= 0;
        end else begin
            case (state)
                IDLE: begin
                    if (valid) begin
                        state <= PROCESS;
                        ready <= 0;
                    end
                end
                PROCESS: begin
                    // Simplified DCT processing (to be replaced with actual DCT algorithm)
                    dct_coeffs <= pixel_block; // Placeholder for actual DCT computation
                    state <= OUTPUT;
                end
                OUTPUT: begin
                    ready <= 1; // Signal that output is ready
                    state <= IDLE;
                end
            endcase
        end
    end
endmodule