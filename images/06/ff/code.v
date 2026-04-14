module echo_cancellation (
    input wire clk,
    input wire rst,
    input wire [7:0] current_input,
    output reg [7:0] output_signal
);
    reg [7:0] previous_input;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            previous_input <= 8'b0;
            output_signal <= 8'b0;
        end else begin
            output_signal <= current_input - previous_input;
            previous_input <= current_input;
        end
    end
endmodule