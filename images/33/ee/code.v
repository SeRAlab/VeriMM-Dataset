module convolutional_encoder(
    input wire clk,
    input wire reset,
    input wire data_in,
    output reg [1:0] data_out
);
    reg [2:0] state; // Internal state (3 bits for constraint length of 3)

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= 3'b000; // Reset state
            data_out <= 2'b00;
        end else begin
            // Shift the state
            state <= {state[1:0], data_in};
            // Generate output based on the current state and input
            data_out[0] <= state[2] ^ state[1] ^ data_in; // g1 = 110
            data_out[1] <= state[2] ^ state[0] ^ data_in; // g2 = 101
        end
    end
endmodule