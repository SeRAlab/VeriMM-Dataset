module hmac (
    input wire clk,
    input wire reset,
    input wire start,
    input wire [127:0] key,
    input wire [127:0] message,
    output reg [127:0] output_hmac,
    output reg valid
);
    reg [1:0] state;
    parameter IDLE = 2'b00, PROCESS = 2'b01, DONE = 2'b10;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            output_hmac <= 128'b0;
            valid <= 0;
        end else begin
            case (state)
                IDLE: begin
                    if (start) begin
                        state <= PROCESS;
                        valid <= 0;
                    end
                end
                PROCESS: begin
                    // Simple HMAC calculation using XOR for illustration.
                    output_hmac <= key ^ message;
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