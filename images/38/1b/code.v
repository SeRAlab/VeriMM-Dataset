module convolutional_encoder (
    input clk,
    input rst,
    input data_in,
    output reg [1:0] data_out
);
    reg [1:0] state;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= 2'b00;
            data_out <= 2'b00;
        end else begin
            state <= {state[0], data_in}; // Shift in the new bit
            data_out[0] <= state[1] ^ state[0] ^ data_in; // G1 = 101
            data_out[1] <= state[1] ^ data_in; // G2 = 111
        end
    end
endmodule