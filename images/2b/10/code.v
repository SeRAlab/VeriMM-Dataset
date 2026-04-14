module sha256 (
    input wire clk,
    input wire rst,
    input wire [511:0] message,
    input wire start,
    output reg [255:0] hash,
    output reg done
);

    reg [511:0] message_reg;
    reg [255:0] hash_reg;
    reg [4:0] state;

    localparam IDLE = 0, PROCESS = 1, DONE = 2;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
            hash <= 256'b0;
            done <= 0;
        end else begin
            case (state)
                IDLE: begin
                    if (start) begin
                        message_reg <= message;
                        hash_reg <= 256'h6a09e667bb67ae8584caa73b2c9f8b1f;
                        state <= PROCESS;
                    end
                end
                PROCESS: begin
                    // Simplified processing logic (not a real SHA-256 implementation)
                    hash_reg <= hash_reg ^ message_reg[255:0]; // Example operation
                    state <= DONE;
                end
                DONE: begin
                    hash <= hash_reg;
                    done <= 1;
                    state <= IDLE; // Return to IDLE to allow for new input
                end
            endcase
        end
    end
endmodule