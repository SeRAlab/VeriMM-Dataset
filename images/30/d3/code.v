module sata_controller (
    input clk,
    input rst,
    input cmd,           // Command input signal
    output reg [1:0] state, // State output (IDLE = 2'b00, COMMAND_RECEIVE = 2'b01, DATA_TRANSFER = 2'b10, COMMAND_COMPLETE = 2'b11)
    output reg cmd_done  // Command done output
);
    // State encoding
    localparam IDLE = 2'b00;
    localparam COMMAND_RECEIVE = 2'b01;
    localparam DATA_TRANSFER = 2'b10;
    localparam COMMAND_COMPLETE = 2'b11;

    // Sequential logic
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
            cmd_done <= 0;
        end else begin
            case (state)
                IDLE: begin
                    cmd_done <= 0;
                    if (cmd) state <= COMMAND_RECEIVE;
                end
                COMMAND_RECEIVE: begin
                    state <= DATA_TRANSFER;
                end
                DATA_TRANSFER: begin
                    state <= COMMAND_COMPLETE;
                end
                COMMAND_COMPLETE: begin
                    cmd_done <= 1;
                    state <= IDLE; // Return to IDLE after completing command
                end
            endcase
        end
    end
endmodule