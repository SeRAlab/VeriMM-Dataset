module audio_compression (
    input clk,
    input reset,
    input [15:0] audio_sample,
    input valid_sample,
    output reg [15:0] compressed_output,
    output reg valid_output
);
    parameter IDLE = 2'b00, READ = 2'b01, COMPRESS = 2'b10, OUTPUT = 2'b11;
    reg [1:0] state, next_state;
    reg [15:0] sample_buffer;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            compressed_output <= 16'b0;
            valid_output <= 1'b0;
            sample_buffer <= 16'b0;
        end else begin
            state <= next_state;
        end
    end

    always @(*) begin
        case (state)
            IDLE: begin
                if (valid_sample) next_state = READ;
                else next_state = IDLE;
            end
            READ: begin
                sample_buffer = audio_sample;
                next_state = COMPRESS;
            end
            COMPRESS: begin
                compressed_output = sample_buffer >> 1; // Simple compression by halving the value
                valid_output = 1'b1;
                next_state = OUTPUT;
            end
            OUTPUT: begin
                valid_output = 1'b0; // Reset output valid signal
                next_state = IDLE; // Return to IDLE
            end
            default: next_state = IDLE;
        endcase
    end
endmodule