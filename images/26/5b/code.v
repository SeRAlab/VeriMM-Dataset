module HMAC(
    input clk,
    input rst,
    input [255:0] key,
    input [255:0] message,
    input start,
    output reg [255:0] hmac_output,
    output reg done
);
    reg [2:0] state;
    localparam IDLE = 3'b000,
               HASH1 = 3'b001,
               HASH2 = 3'b010,
               DONE = 3'b011;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
            hmac_output <= 256'b0;
            done <= 1'b0;
        end else begin
            case (state)
                IDLE: begin
                    if (start) begin
                        state <= HASH1;
                        done <= 1'b0;
                    end
                end
                HASH1: begin
                    // Placeholder for first hash computation stage
                    // (key XOR ipad) + message
                    hmac_output <= key ^ 256'h36363636363636363636363636363636; // ipad
                    state <= HASH2;
                end
                HASH2: begin
                    // Placeholder for second hash computation stage
                    // (key XOR opad) + H((key XOR ipad) + message)
                    hmac_output <= hmac_output ^ 256'h5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c; // opad
                    // Here we would perform actual SHA-256 hashing
                    state <= DONE;
                end
                DONE: begin
                    done <= 1'b1;
                    state <= IDLE; // go back to idle
                end
            endcase
        end
    end
endmodule