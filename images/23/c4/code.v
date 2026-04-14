module aes_encrypt (
    input wire clk,
    input wire rst,
    input wire start,
    input wire [127:0] plaintext,
    input wire [127:0] key,
    output reg [127:0] ciphertext,
    output reg done
);
    reg [3:0] state;
    reg [127:0] round_key;
    reg [127:0] state_data;

    localparam IDLE = 0, KEY_EXPAND = 1, ROUND = 2, FINALIZE = 3;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
            done <= 0;
            ciphertext <= 0;
        end else begin
            case (state)
                IDLE: begin
                    if (start) begin
                        state_data <= plaintext;
                        round_key <= key;
                        state <= KEY_EXPAND;
                    end
                end
                KEY_EXPAND: begin
                    // For simplicity, just use the original key as round key
                    state <= ROUND;
                end
                ROUND: begin
                    // Simple round function: XOR state with round key
                    state_data <= state_data ^ round_key;
                    state <= FINALIZE;
                end
                FINALIZE: begin
                    ciphertext <= state_data;
                    done <= 1;
                    state <= IDLE; // Go back to idle after done
                end
            endcase
        end
    end
endmodule