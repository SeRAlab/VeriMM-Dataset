module convolutional_encoder(
    input clk,
    input reset,
    input data_in,
    output reg encoded_out1,
    output reg encoded_out2
);
    reg [2:0] state; // 3-bit state for the encoder

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= 3'b000;
            encoded_out1 <= 0;
            encoded_out2 <= 0;
        end else begin
            // Shift in the new data
            state <= {data_in, state[2:1]};
            // Generate outputs based on the current state and input
            encoded_out1 <= state[2] ^ state[1] ^ data_in; // G1 = 111
            encoded_out2 <= state[2] ^ state[0];          // G2 = 101
        end
    end
endmodule