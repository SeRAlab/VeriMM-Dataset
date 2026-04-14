module png_compressor(
    input wire clk,
    input wire start,
    output reg [1:0] state
);
    // State encoding
    parameter IDLE = 2'b00;
    parameter HEADER = 2'b01;
    parameter COMPRESS = 2'b10;

    // Initial state
    initial begin
        state = IDLE;
    end

    // State transition logic
    always @(posedge clk) begin
        case (state)
            IDLE: begin
                if (start) begin
                    state <= HEADER;
                end
            end
            HEADER: begin
                state <= COMPRESS;
            end
            COMPRESS: begin
                state <= IDLE;
            end
            default: state <= IDLE;
        endcase
    end
endmodule