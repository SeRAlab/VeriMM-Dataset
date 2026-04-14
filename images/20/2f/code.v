module turbo_encoder (
    input clk,
    input reset,
    input data_in,
    output reg [1:0] encoded_out
);
    reg [1:0] state; // State for first encoder
    reg [1:0] interleaved_data; // Interleaved output

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= 2'b00;
            encoded_out <= 2'b00;
        end else begin
            state <= {data_in, state[1]}; // Shift in new data
            interleaved_data <= {state[0], data_in}; // Interleave data
            encoded_out <= {state[0] ^ state[1], interleaved_data[1]}; // Simple encoding logic
        end
    end
endmodule