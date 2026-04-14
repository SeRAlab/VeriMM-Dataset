module lzw_compressor(
    input clk,
    input reset,
    input [7:0] data_in,
    output reg [15:0] compressed_out,
    output reg valid
);
    // Internal states to store the current and previous patterns
    reg [7:0] current_pattern;
    reg [7:0] previous_pattern;
    reg [3:0] state;
    
    // State encoding
    localparam IDLE = 4'b0000,
               READ = 4'b0001,
               COMPRESS = 4'b0010;

    // Initialization
    initial begin
        state = IDLE;
        valid = 0;
        compressed_out = 0;
    end

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            valid <= 0;
            compressed_out <= 0;
        end else begin
            case (state)
                IDLE: begin
                    if (data_in) begin
                        current_pattern <= data_in;
                        state <= READ;
                    end
                end
                READ: begin
                    if (data_in != current_pattern) begin
                        previous_pattern <= current_pattern;
                        current_pattern <= data_in;
                        state <= COMPRESS;
                    end
                end
                COMPRESS: begin
                    compressed_out <= {previous_pattern, current_pattern};
                    valid <= 1;
                    state <= IDLE;
                end
            endcase
        end
    end
endmodule