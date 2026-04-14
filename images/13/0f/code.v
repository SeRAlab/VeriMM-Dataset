module rsa_encrypt (
    input clk,
    input rst,
    input start,
    input [127:0] plaintext,      // 128-bit plaintext
    input [127:0] n,              // 128-bit modulus
    input [127:0] e,              // 128-bit public exponent
    output reg [127:0] ciphertext, // 128-bit ciphertext
    output reg done
);

reg [127:0] temp;
reg [127:0] exp;
reg [127:0] base;
reg [3:0] state;

localparam IDLE = 0;
localparam LOAD = 1;
localparam CALC = 2;
localparam DONE = 3;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        state <= IDLE;
        ciphertext <= 0;
        done <= 0;
    end else begin
        case (state)
            IDLE: begin
                if (start) begin
                    base <= plaintext; // Load plaintext as base
                    exp <= e;         // Load exponent
                    temp <= 1;        // Start with temp = 1
                    state <= LOAD;
                    done <= 0;
                end
            end
            LOAD: begin
                if (exp != 0) begin
                    if (exp[0]) begin
                        temp <= (temp * base) % n; // Multiply temp by base mod n
                    end
                    base <= (base * base) % n;   // Square the base mod n
                    exp <= exp >> 1;              // Right shift exponent
                end else begin
                    ciphertext <= temp; // Store ciphertext
                    state <= DONE;
                end
            end
            DONE: begin
                done <= 1; // Indicate operation is complete
                state <= IDLE; // Go back to idle
            end
        endcase
    end
end

endmodule