module nvme_controller (
    input wire clk,
    input wire reset,
    input wire start_read,
    input wire start_write,
    output reg [1:0] state // 00: IDLE, 01: READ, 10: WRITE
);

    // State encoding
    localparam IDLE = 2'b00;
    localparam READ = 2'b01;
    localparam WRITE = 2'b10;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
        end else begin
            case (state)
                IDLE: begin
                    if (start_read) state <= READ;
                    else if (start_write) state <= WRITE;
                end
                READ: begin
                    if (!start_read) state <= IDLE; // transition back to IDLE
                end
                WRITE: begin
                    if (!start_write) state <= IDLE; // transition back to IDLE
                end
            endcase
        end
    end
endmodule