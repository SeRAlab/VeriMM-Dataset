module convolutional_encoder (
    input clk,
    input reset,
    input data_in,
    output reg [1:0] data_out
);

    reg [1:0] state;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= 2'b00;
            data_out <= 2'b00;
        end else begin
            // Shift the state
            state <= {state[0], data_in};

            // Generate output
            data_out[0] <= state[1] ^ state[0] ^ data_in; // G1 = 110
            data_out[1] <= state[1] ^ data_in;           // G2 = 101
        end
    end
endmodule