module nvme_controller (
    input wire clk,
    input wire reset,
    input wire [1:0] cmd, // 00: IDLE, 01: READ, 10: WRITE
    output reg [1:0] state // 00: IDLE, 01: READ, 10: WRITE, 11: DONE
);
    // State Encoding
    localparam IDLE = 2'b00;
    localparam READ = 2'b01;
    localparam WRITE = 2'b10;
    localparam DONE = 2'b11;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
        end else begin
            case (state)
                IDLE: begin
                    if (cmd == 2'b01) begin
                        state <= READ;
                    end else if (cmd == 2'b10) begin
                        state <= WRITE;
                    end
                end
                READ: begin
                    state <= DONE;
                end
                WRITE: begin
                    state <= DONE;
                end
                DONE: begin
                    state <= IDLE;
                end
                default: state <= IDLE;
            endcase
        end
    end
endmodule