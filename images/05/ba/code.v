module rnn_inference (
    input clk,
    input reset,
    input data_in,
    output reg hidden_state
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            hidden_state <= 1'b0; // initial hidden state
        end else begin
            hidden_state <= (hidden_state ^ data_in); // simple XOR operation for state update
        end
    end
endmodule