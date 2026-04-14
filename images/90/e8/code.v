module top_module(
    input [31:0] audio_in_data,
    input audio_in_valid,
    output reg audio_in_ready,
    output reg [31:0] audio_out_data,
    output reg audio_out_valid,
    input audio_out_ready
);reg [31:0] audio_in_data_reg;

    always @(*) begin
        // Default values
        audio_out_valid = 0;
        audio_in_ready = 0;

        if (audio_in_valid && audio_out_ready) begin
            audio_out_data = audio_in_data;
            audio_out_valid = 1;
            audio_in_ready = 1;
            audio_in_data_reg = audio_in_data; // Optional if you need to store it
        end
    end

endmodule