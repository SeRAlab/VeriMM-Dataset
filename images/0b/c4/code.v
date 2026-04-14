module convolutional_encoder (
    input wire clk,
    input wire reset,
    input wire data_in,
    output reg [1:0] data_out
);

    reg [2:0] state; // 3-bit state for constraint length of 3

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= 3'b000; // Reset state
            data_out <= 2'b00; // Reset output
        end else begin
            // Shift the state left and insert the new input
            state <= {state[1:0], data_in};

            // Calculate output using the polynomial generator functions
            data_out[0] <= state[2] ^ state[1] ^ data_in; // G1 = 101
            data_out[1] <= state[2] ^ state[1] ^ state[0]; // G2 = 111
        end
    end
endmodule