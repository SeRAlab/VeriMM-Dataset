module convolutional_encoder (
    input clk,
    input reset,
    input data_in,
    output reg [1:0] encoded_out
);
    reg [2:0] state; // 2 bits for the two output streams, 1 bit for the input data

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= 3'b000;
            encoded_out <= 2'b00;
        end else begin
            state <= {data_in, state[2:1]};
            encoded_out[0] <= state[0] ^ state[1] ^ state[2]; // G1 = 111
            encoded_out[1] <= state[0] ^ state[2]; // G2 = 101
        end
    end
endmodule