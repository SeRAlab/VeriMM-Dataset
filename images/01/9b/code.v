module LZW_FSM (
    input clk,
    input reset,
    input [7:0] char_in,
    output reg [11:0] code_out,
    output reg valid
);
    reg [3:0] state;
    reg [7:0] buffer [0:15];
    integer i;

    initial begin
        state = 0;
        valid = 0;
        code_out = 12'b0;
    end

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= 0;
            valid <= 0;
            code_out <= 12'b0;
            for (i = 0; i < 16; i = i + 1) buffer[i] = 8'b0;
        end else begin
            buffer[state] <= char_in; // Store input char in buffer
            // Pseudo LZW logic for demonstration
            code_out <= state; // Output the state as code
            valid <= 1; // Indicate a valid output
            state <= (state + 1) % 16; // Simple state transition
        end
    end
endmodule