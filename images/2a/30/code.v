module convolutional_encoder (
    input clk,
    input rst,
    input din,
    output reg dout0,
    output reg dout1
);
    reg [1:0] state; // 2-bit memory for previous state

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= 2'b00;
            dout0 <= 1'b0;
            dout1 <= 1'b0;
        end else begin
            dout0 <= state[0] ^ state[1]; // Output bit 0
            dout1 <= state[1] ^ din;       // Output bit 1
            state <= {din, state[0]};      // Update state
        end
    end
endmodule