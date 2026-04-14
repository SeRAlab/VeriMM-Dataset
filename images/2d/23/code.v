module dpcm_encoder(
    input wire clk,
    input wire reset,
    input wire [7:0] current_sample,
    output reg [7:0] predicted_sample,
    output reg [7:0] error_signal
);
    reg [7:0] previous_sample;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            previous_sample <= 8'b0;
            predicted_sample <= 8'b0;
            error_signal <= 8'b0;
        end else begin
            predicted_sample <= previous_sample; // Prediction is previous sample
            error_signal <= current_sample - predicted_sample; // Calculate error
            previous_sample <= current_sample; // Update previous sample
        end
    end
endmodule