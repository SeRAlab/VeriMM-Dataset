module hmac (
    input clk,
    input rst,
    input start,
    input [7:0] key,
    input [7:0] message,
    output reg [7:0] hmac_out,
    output reg done
);
    reg [1:0] state;
    localparam IDLE = 2'b00, PROCESS = 2'b01, OUTPUT = 2'b10;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
            hmac_out <= 8'b0;
            done <= 0;
        end else begin
            case (state)
                IDLE: begin
                    if (start) begin
                        state <= PROCESS;
                        done <= 0;
                    end
                end
                PROCESS: begin
                    hmac_out <= key ^ message; // Simple hash operation using XOR
                    state <= OUTPUT;
                end
                OUTPUT: begin
                    done <= 1; // Indicate that the output is ready
                    state <= IDLE;
                end
            endcase
        end
    end
endmodule