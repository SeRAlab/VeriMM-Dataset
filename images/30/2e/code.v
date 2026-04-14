module convolutional_encoder (
    input clk,
    input reset,
    input data_in,
    output reg [1:0] data_out
);
    reg [1:0] state; // 2-bit state to keep track of the previous bits
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= 2'b00;
            data_out <= 2'b00;
        end else begin
            state = {state[0], data_in}; // Shift in the new bit
            data_out <= {state[1] ^ data_in, state[0] ^ data_in}; // Convolutional encoding
        end
    end
endmodule