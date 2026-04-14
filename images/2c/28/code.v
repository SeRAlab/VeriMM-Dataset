module convolutional_encoder(
    input wire clk,
    input wire reset,
    input wire data_in,
    output reg [1:0] data_out
);
    reg data_prev1, data_prev2;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            data_prev1 <= 0;
            data_prev2 <= 0;
            data_out <= 0;
        end else begin
            data_out[0] <= data_in ^ data_prev1; // First output bit
            data_out[1] <= data_in ^ data_prev1 ^ data_prev2; // Second output bit
            
            // Shift registers
            data_prev2 <= data_prev1;
            data_prev1 <= data_in;
        end
    end
endmodule