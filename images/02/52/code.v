module noise_suppression(
    input clk,
    input rst,
    input signal_in,
    output reg signal_out
);
    reg [2:0] state; // 3-bit state to store the last three inputs

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= 3'b000;
            signal_out <= 0;
        end else begin
            state <= {state[1:0], signal_in}; // Shift in the new signal
            // Output 1 only if the last three signals are all 1
            if (state == 3'b111) begin
                signal_out <= 1;
            end else begin
                signal_out <= 0;
            end
        end
    end
endmodule