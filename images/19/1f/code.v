module convolutional_encoder(
    input clk,
    input reset,
    input data_in,
    output reg [1:0] data_out
);
    reg [1:0] state; // Two flip-flops for the state

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= 2'b00; // Reset state
            data_out <= 2'b00;
        end else begin
            // Convolutional encoding logic
            data_out[0] <= state[0] ^ state[1] ^ data_in; // Output bit 1
            data_out[1] <= state[1] ^ data_in; // Output bit 2

            // State transition
            state <= {data_in, state[1]}; // Shift in the data_in
        end
    end
endmodule