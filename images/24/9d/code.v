module echo_cancellation (
    input wire clk,
    input wire rst,
    input wire [7:0] input_signal,
    input wire [7:0] echo_signal,
    output reg [7:0] output_signal
);
    reg [7:0] prev_input;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            prev_input <= 8'b0;
            output_signal <= 8'b0;
        end else begin
            output_signal <= input_signal - echo_signal;
            prev_input <= input_signal; // Store the current input for future use if needed
        end
    end
endmodule