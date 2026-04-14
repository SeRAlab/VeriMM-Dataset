module arq_system (
    input wire clk,
    input wire reset,
    input wire [7:0] data_in,
    input wire ack,
    output reg [7:0] data_out,
    output reg send,
    output reg retry
);
    reg [2:0] state;
    reg [2:0] retry_count;
    parameter IDLE = 3'b000, SEND = 3'b001, WAIT_ACK = 3'b010, RETRY = 3'b011, DONE = 3'b100;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            retry_count <= 0;
            send <= 0;
            retry <= 0;
        end else begin
            case (state)
                IDLE: begin
                    data_out <= data_in; // Prepare data to send
                    state <= SEND;
                end
                
                SEND: begin
                    send <= 1; // Indicate sending data
                    state <= WAIT_ACK;
                end
                
                WAIT_ACK: begin
                    if (ack) begin
                        send <= 0; // Acknowledged
                        state <= DONE;
                    end else begin
                        if (retry_count < 3) begin
                            retry_count <= retry_count + 1;
                            state <= RETRY;
                        end else begin
                            state <= DONE; // Give up after retries
                        end
                    end
                end
                
                RETRY: begin
                    send <= 1; // Retry sending data
                    state <= WAIT_ACK;
                end
                
                DONE: begin
                    send <= 0;
                    retry <= 0; // Finish operation
                    state <= IDLE; // Reset state to IDLE
                end
            endcase
        end
    end
endmodule