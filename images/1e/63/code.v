module convolutional_encoder (
    input wire clk,
    input wire reset,
    input wire [4:0] data_in,
    output reg [9:0] encoded_out
);
    reg [2:0] state;
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= 3'b000;
            encoded_out <= 10'b0;
        end else begin
            // Shift in new data and calculate encoded output
            state <= {state[1:0], data_in[0]};
            encoded_out <= {state[2] ^ state[1], state[2] ^ state[0], state[2] ^ data_in[0],
                            state[2] ^ state[1] ^ data_in[0], state[2] ^ state[0] ^ data_in[0]};
        end
    end
endmodule