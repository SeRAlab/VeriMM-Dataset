module RSA_Encryption (
    input clk,
    input reset,
    input [7:0] plaintext,
    input [11:0] e,
    input [11:0] n,
    output reg [11:0] ciphertext,
    output reg done
);
    reg [11:0] result;
    reg [3:0] state;
    reg [3:0] count;
    
    localparam IDLE = 4'd0;
    localparam COMPUTE = 4'd1;
    localparam DONE = 4'd2;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            ciphertext <= 12'd0;
            done <= 1'b0;
            count <= 4'd0;
            result <= 12'd1; // Initialize result for multiplication
        end else begin
            case (state)
                IDLE: begin
                    if (plaintext != 8'd0) begin
                        result <= 12'd1; // Start with result = 1
                        count <= 4'd0;
                        state <= COMPUTE;
                    end
                end
                COMPUTE: begin
                    if (count < e) begin
                        result <= (result * plaintext) % n; // Compute (result * plaintext) mod n
                        count <= count + 1;
                    end else begin
                        ciphertext <= result; // Assign result to ciphertext
                        done <= 1'b1; // Signal that computation is done
                        state <= DONE;
                    end
                end
                DONE: begin
                    // Remain in DONE state until reset
                end
            endcase
        end
    end
endmodule