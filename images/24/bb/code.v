module hmac (
    input clk,
    input rst,
    input start,
    input [7:0] key,
    input [7:0] message,
    output reg [15:0] hmac_out,
    output reg done
);
    reg [3:0] state;
    reg [15:0] hash;
    
    localparam IDLE = 0, PROCESS = 1, DONE = 2;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
            hmac_out <= 16'h0000;
            hash <= 16'h0000;
            done <= 0;
        end else begin
            case (state)
                IDLE: begin
                    if (start) begin
                        hash <= key ^ message; // Simple hash operation
                        state <= PROCESS;
                        done <= 0;
                    end
                end
                PROCESS: begin
                    hmac_out <= hash + 16'hAAAA; // Simple HMAC calculation
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