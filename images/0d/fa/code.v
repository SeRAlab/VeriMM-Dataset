module convolutional_encoder (
    input clk,
    input reset,
    input in_bit,
    output reg out_bit1,
    output reg out_bit2
);
    reg [2:0] state; // 3-bit state for memory of constraint length 3

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= 3'b000;
            out_bit1 <= 0;
            out_bit2 <= 0;
        end else begin
            // Shift state and add new input bit
            state <= {state[1:0], in_bit};
            // Calculate output bits based on the current state
            out_bit1 <= state[2] ^ state[1] ^ in_bit; // G1: 101
            out_bit2 <= state[2] ^ state[1] ^ state[0]; // G2: 111
        end
    end
endmodule