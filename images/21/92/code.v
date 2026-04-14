module audio_compressor(
    input clk,
    input rst,
    input [15:0] audio_in,
    output reg [15:0] audio_out
);
    reg [1:0] state, next_state;
    parameter IDLE = 2'b00, PROCESS = 2'b01;
    parameter THRESHOLD = 16'd10000;

    always @(posedge clk or posedge rst) begin
        if (rst)
            state <= IDLE;
        else
            state <= next_state;
    end

    always @(*) begin
        case (state)
            IDLE: begin
                if (audio_in !== 16'bx) // Check for valid input
                    next_state = PROCESS;
                else
                    next_state = IDLE;
            end
            PROCESS: begin
                next_state = IDLE;
            end
            default: next_state = IDLE;
        endcase
    end

    always @(posedge clk) begin
        if (state == PROCESS) begin
            if (audio_in > THRESHOLD)
                audio_out <= audio_in >> 1; // Simple compression by halving
            else
                audio_out <= audio_in;
        end
        else
            audio_out <= 16'b0; // Default output when idle
    end
endmodule