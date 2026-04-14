module HMAC (
    input wire clk,
    input wire reset,
    input wire start,
    input wire [7:0] key,
    input wire [7:0] message,
    output reg [7:0] hmac_output,
    output reg valid
);
    reg [1:0] state;
    
    localparam IDLE = 2'b00,
               PROCESS = 2'b01,
               DONE = 2'b10;
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            hmac_output <= 8'b0;
            valid <= 0;
        end else begin
            case (state)
                IDLE: begin
                    if (start) begin
                        state <= PROCESS;
                        hmac_output <= key ^ message; // Simple hash using XOR
                        valid <= 0;
                    end
                end
                PROCESS: begin
                    state <= DONE;
                end
                DONE: begin
                    valid <= 1;
                    state <= IDLE;
                end
            endcase
        end
    end
endmodule