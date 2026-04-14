module convolutional_encoder (
    input clk,
    input rst,
    input data_in,
    output reg enc_out1,
    output reg enc_out2
);
    reg [2:0] state; // 3-bit state to hold the previous bits

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= 3'b000;
            enc_out1 <= 0;
            enc_out2 <= 0;
        end else begin
            // Shift the input into the state
            state <= {data_in, state[2:1]};  // Shift in the new bit
            // Compute the output based on the generator polynomials
            enc_out1 <= state[2] ^ state[1] ^ data_in; // g1 = 101
            enc_out2 <= state[2] ^ state[1] ^ state[0]; // g2 = 111
        end
    end
endmodule