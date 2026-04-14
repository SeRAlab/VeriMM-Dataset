module pcie_controller (
    input clk,
    input reset,
    input start_read,
    input start_write,
    output reg [1:0] state,
    output reg transaction_done
);

    parameter IDLE = 2'b00, READ = 2'b01, WRITE = 2'b10;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            transaction_done <= 0;
        end else begin
            case (state)
                IDLE: begin
                    transaction_done <= 0;
                    if (start_read) begin
                        state <= READ;
                    end else if (start_write) begin
                        state <= WRITE;
                    end
                end
                READ: begin
                    // Simulate read transaction
                    transaction_done <= 1;
                    state <= IDLE;
                end
                WRITE: begin
                    // Simulate write transaction
                    transaction_done <= 1;
                    state <= IDLE;
                end
            endcase
        end
    end
endmodule