module conv_encoder (
    input clk,
    input reset,
    input data_in,
    output reg [1:0] data_out
);
    reg [2:0] state; // 3-bit state to hold the last two bits of input

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= 3'b000;
            data_out <= 2'b00;
        end else begin
            state <= {state[1:0], data_in}; // Shift in new data
            data_out <= {state[1] ^ state[0] ^ data_in, state[0] ^ data_in}; // g1 = 111, g2 = 101
        end
    end
endmodule