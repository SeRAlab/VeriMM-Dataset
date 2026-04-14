module convolutional_encoder (
    input clk,
    input reset,
    input data_in,
    output reg [1:0] data_out
);
    // State register
    reg [2:0] state;

    // Polynomials: g1 = 111, g2 = 101
    wire g1, g2;

    assign g1 = state[2] ^ state[1] ^ data_in;
    assign g2 = state[2] ^ data_in;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= 3'b000;
            data_out <= 2'b00;
        end else begin
            state <= {state[1:0], data_in}; // Shift in the new bit
            data_out <= {g1, g2};
        end
    end
endmodule