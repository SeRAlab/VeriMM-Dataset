module rnn_inference (
    input clk,
    input rst,
    input din,
    output reg dout
);
    reg hidden_state;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            hidden_state <= 0;
            dout <= 0;
        end else begin
            hidden_state <= din ^ hidden_state; // Simple activation function (XOR)
            dout <= hidden_state; // Output the current hidden state
        end
    end
endmodule