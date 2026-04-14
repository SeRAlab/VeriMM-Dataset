module convolutional_encoder (
    input clk,
    input reset,
    input data_in,
    output reg data_out1,
    output reg data_out2
);
    reg [1:0] state; // to hold the previous two inputs

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= 2'b00; // reset state
            data_out1 <= 0;
            data_out2 <= 0;
        end else begin
            data_out1 <= data_in ^ state[1] ^ state[0]; // First output
            data_out2 <= data_in ^ state[1];            // Second output
            state <= {state[0], data_in};               // Shift input into state
        end
    end
endmodule