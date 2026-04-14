module convolutional_encoder (
    input wire clk,
    input wire reset,
    input wire start,
    input wire [3:0] data_in,
    output reg [7:0] encoded_out,
    output reg done
);
    reg [2:0] state; // State to store the previous two bits
    reg [3:0] data_reg;
    integer i;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= 3'b000;
            encoded_out <= 8'b0;
            done <= 0;
        end else if (start) begin
            data_reg <= data_in;
            encoded_out <= 8'b0;
            done <= 0;
            for (i = 0; i < 4; i = i + 1) begin
                // Shift the state left and add the new data bit
                state <= {state[1:0], data_reg[i]};
                encoded_out[i*2] <= state[0] ^ state[1] ^ state[2]; // G1
                encoded_out[i*2 + 1] <= state[0] ^ state[2];       // G2
            end
            done <= 1;
        end
    end
endmodule