module nvme_command_controller (
    input wire clk,
    input wire reset,
    input wire [7:0] command_in,
    input wire command_valid,
    output reg command_processed,
    output reg [7:0] command_out
);
    reg [2:0] state;

    parameter IDLE = 3'b000,
              PROCESS = 3'b001,
              DONE = 3'b010;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            command_processed <= 0;
            command_out <= 0;
        end else begin
            case (state)
                IDLE: begin
                    if (command_valid) begin
                        command_out <= command_in;
                        state <= PROCESS;
                    end
                end
                PROCESS: begin
                    command_processed <= 1; // Indicate command is processed
                    state <= DONE;
                end
                DONE: begin
                    state <= IDLE; // Go back to IDLE after processing
                    command_processed <= 0; // Reset processed flag
                end
            endcase
        end
    end
endmodule