module pcie_endpoint_controller(
    input clk,
    input reset,
    input req_read,
    input req_write,
    input ack,
    output reg [1:0] state, // 00: IDLE, 01: READ, 10: WRITE, 11: ERROR
    output reg processing_read,
    output reg processing_write
);

    // State encoding
    localparam IDLE = 2'b00;
    localparam READ = 2'b01;
    localparam WRITE = 2'b10;
    localparam ERROR = 2'b11;

    // State transition
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            processing_read <= 0;
            processing_write <= 0;
        end else begin
            case (state)
                IDLE: begin
                    if (req_read) begin
                        state <= READ;
                        processing_read <= 1;
                    end else if (req_write) begin
                        state <= WRITE;
                        processing_write <= 1;
                    end
                end
                READ: begin
                    if (ack) begin
                        state <= IDLE;
                        processing_read <= 0;
                    end else begin
                        state <= ERROR;
                    end
                end
                WRITE: begin
                    if (ack) begin
                        state <= IDLE;
                        processing_write <= 0;
                    end else begin
                        state <= ERROR;
                    end
                end
                ERROR: begin
                    // Stay in ERROR until reset
                    if (reset) begin
                        state <= IDLE;
                    end
                end
            endcase
        end
    end
endmodule