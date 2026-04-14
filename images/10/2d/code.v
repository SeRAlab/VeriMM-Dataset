module nvme_controller (
    input wire clk,
    input wire rst_n,
    input wire start_cmd,
    input wire cmd_done,
    output reg [1:0] state // 00: IDLE, 01: COMMAND, 10: DONE
);
    // State encoding
    localparam IDLE = 2'b00;
    localparam COMMAND = 2'b01;
    localparam DONE = 2'b10;

    // Sequential logic for state transition
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            state <= IDLE;
        else begin
            case (state)
                IDLE: begin
                    if (start_cmd)
                        state <= COMMAND;
                end
                COMMAND: begin
                    if (cmd_done)
                        state <= DONE;
                end
                DONE: begin
                    state <= IDLE; // Reset to IDLE after DONE
                end
            endcase
        end
    end
endmodule