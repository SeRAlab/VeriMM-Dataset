module nvme_controller (
    input clk,
    input rst_n,
    input [1:0] cmd_code, // Command code: 0 for Read, 1 for Write
    input [31:0] lba,     // Logical Block Address
    output reg status      // Operation status: 0 for OK, 1 for Error
);

    // State definitions
    reg [1:0] state;
    localparam IDLE = 2'b00, READ = 2'b01, WRITE = 2'b10;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
            status <= 1'b0; // Default status OK
        end else begin
            case (state)
                IDLE: begin
                    if (cmd_code == 2'b00) begin
                        state <= READ;
                    end else if (cmd_code == 2'b01) begin
                        state <= WRITE;
                    end
                end
                READ: begin
                    // Simulate read operation
                    status <= 1'b0; // Assume read is always successful
                    state <= IDLE;  // Go back to idle after read
                end
                WRITE: begin
                    // Simulate write operation
                    status <= 1'b0; // Assume write is always successful
                    state <= IDLE;  // Go back to idle after write
                end
                default: begin
                    state <= IDLE;  // Safety default
                end
            endcase
        end
    end
endmodule