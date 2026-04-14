module echo_canceller (
    input wire clk,
    input wire rst,
    input wire [15:0] input_signal,
    input wire [15:0] reference_signal,
    output reg [15:0] output_signal
);

always @(posedge clk or posedge rst) begin
    if (rst) begin
        output_signal <= 16'd0;
    end else begin
        output_signal <= input_signal - reference_signal;
    end
end

endmodule