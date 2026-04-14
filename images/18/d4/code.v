module phase_shifter (
    input wire clk,
    input wire reset,
    input wire [1:0] phase_control, // 00, 01, 10, 11
    input wire [1:0] input_signal,
    output reg [1:0] output_signal
);
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            output_signal <= 2'b00; // reset output
        end else begin
            case (phase_control)
                2'b00: output_signal <= input_signal;          // 0° shift
                2'b01: output_signal <= {input_signal[0], input_signal[1]}; // 90° shift
                2'b10: output_signal <= {input_signal[1], input_signal[0]}; // 180° shift
                2'b11: output_signal <= {input_signal[1], input_signal[0]}; // 270° shift
                default: output_signal <= 2'b00;
            endcase
        end
    end
endmodule