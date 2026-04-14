module mpc_controller (
    input wire clk,
    input wire reset,
    input wire [7:0] input_signal,
    output reg [7:0] output_signal
);
    parameter MIN_OUTPUT = 8'd50;
    parameter MAX_OUTPUT = 8'd200;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            output_signal <= MIN_OUTPUT;
        end else begin
            if (input_signal < MIN_OUTPUT)
                output_signal <= MIN_OUTPUT;
            else if (input_signal > MAX_OUTPUT)
                output_signal <= MAX_OUTPUT;
            else
                output_signal <= input_signal;
        end
    end
endmodule