module convolutional_encoder (
    input clk,
    input reset,
    input data_in,
    output reg [1:0] data_out
);
    reg [2:0] state; // 3 bits for the state
    wire g1, g2;

    assign g1 = state[2] ^ state[1] ^ state[0]; // g1 = 111
    assign g2 = state[2] ^ state[0];           // g2 = 101

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= 3'b000; // Reset state
            data_out <= 2'b00;
        end else begin
            data_out <= {g1, g2}; // Output the encoded bits
            state <= {state[1:0], data_in}; // Shift in the new bit
        end
    end
endmodule