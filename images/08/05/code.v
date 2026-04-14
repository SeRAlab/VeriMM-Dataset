module nvme_controller (
    input wire clk,
    input wire reset,
    input wire read_req,
    input wire write_req,
    output reg [1:0] status
);
    reg [1:0] state;
    localparam IDLE = 2'b00, PROCESSING = 2'b01, DONE = 2'b10;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            status <= 2'b00;
        end else begin
            case (state)
                IDLE: begin
                    if (read_req || write_req) begin
                        state <= PROCESSING;
                        status <= 2'b01; // Processing
                    end
                end
                PROCESSING: begin
                    // Simulate some processing time
                    state <= DONE;
                    status <= 2'b01; // Still processing
                end
                DONE: begin
                    state <= IDLE;
                    status <= 2'b10; // Done
                end
            endcase
        end
    end
endmodule