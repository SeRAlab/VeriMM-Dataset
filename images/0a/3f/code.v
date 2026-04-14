module convolutional_encoder (
    input wire clk,
    input wire reset,
    input wire data_in,
    output reg [1:0] data_out
);
    reg [1:0] state; // 2-bit state register

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= 2'b00; // Reset state
            data_out <= 2'b00;
        end else begin
            // Shift left and insert new input
            state <= {state[0], data_in}; 
            // Generate output based on the current state and input
            data_out[0] <= state[0] ^ data_in; // Output for g1
            data_out[1] <= state[1] ^ state[0] ^ data_in; // Output for g2
        end
    end
endmodule