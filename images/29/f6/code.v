module turbo_encoder (
    input clk,
    input reset,
    input data_in,
    output reg [1:0] data_out
);
    reg [1:0] state;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= 2'b00;
            data_out <= 2'b00;
        end else begin
            // Simple encoding logic
            data_out[0] <= data_in ^ state[0]; // First output bit
            data_out[1] <= data_in ^ state[1]; // Second output bit
            state <= {data_in, state[0]}; // Update state
        end
    end
endmodule