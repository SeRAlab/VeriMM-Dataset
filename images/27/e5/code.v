module HMAC (
    input wire clk,
    input wire reset,
    input wire [63:0] key,
    input wire [63:0] message,
    input wire start,
    output reg [127:0] hash,
    output reg done
);
    reg [127:0] inner_hash;
    reg [127:0] outer_hash;
    reg [3:0] state;

    parameter IDLE = 0, INNER = 1, OUTER = 2, DONE = 3;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            hash <= 0;
            done <= 0;
        end else begin
            case (state)
                IDLE: begin
                    if (start) begin
                        state <= INNER;
                    end
                end
                INNER: begin
                    inner_hash <= key ^ message; // Simple XOR as inner hash
                    state <= OUTER;
                end
                OUTER: begin
                    outer_hash <= inner_hash ^ key; // Simple XOR as outer hash
                    hash <= outer_hash;
                    state <= DONE;
                end
                DONE: begin
                    done <= 1;
                    state <= IDLE;
                end
            endcase
        end
    end
endmodule