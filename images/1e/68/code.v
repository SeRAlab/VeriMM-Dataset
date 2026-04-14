module md5_hash (
    input clk,
    input reset,
    input [511:0] message,
    input start,
    output reg [127:0] hash,
    output reg done
);
    reg [3:0] state;
    reg [127:0] buffer;
    
    localparam IDLE = 4'b0000,
               PROCESS = 4'b0001,
               FINALIZE = 4'b0010;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            hash <= 128'h0;
            buffer <= 128'h0;
            done <= 0;
        end else begin
            case (state)
                IDLE: begin
                    if (start) begin
                        buffer <= message[127:0]; // For simplicity, just use the first 128 bits
                        state <= PROCESS;
                    end
                end
                PROCESS: begin
                    // Simple transformation example
                    buffer <= (buffer + {buffer[63:0], buffer[127:64]}) ^ (buffer << 1);
                    state <= FINALIZE;
                end
                FINALIZE: begin
                    hash <= buffer;
                    done <= 1;
                    state <= IDLE; // Go back to IDLE
                end
            endcase
        end
    end
endmodule