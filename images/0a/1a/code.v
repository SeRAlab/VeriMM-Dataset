module nvme_controller (
    input clk,
    input reset,
    input start,
    input operation, // 0 for READ, 1 for WRITE
    output reg [1:0] current_state // 00 for IDLE, 01 for READ, 10 for WRITE
);
    parameter IDLE = 2'b00, READ = 2'b01, WRITE = 2'b10;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            current_state <= IDLE;
        end else begin
            case (current_state)
                IDLE: begin
                    if (start) begin
                        if (operation == 0) 
                            current_state <= READ;
                        else 
                            current_state <= WRITE;
                    end
                end
                READ: begin
                    // Simulate operation complete
                    current_state <= IDLE;
                end
                WRITE: begin
                    // Simulate operation complete
                    current_state <= IDLE;
                end
            endcase
        end
    end
endmodule