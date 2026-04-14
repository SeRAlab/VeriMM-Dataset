module nvme_read_controller(
    input wire clk,
    input wire rst,
    input wire start_read,
    input wire [15:0] address,
    output reg [31:0] data_out,
    output reg status // 0: idle, 1: busy, 2: done
);
    reg [1:0] state;
    localparam IDLE = 2'b00, BUSY = 2'b01, DONE = 2'b10;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
            data_out <= 32'b0;
            status <= 0;
        end else begin
            case (state)
                IDLE: begin
                    if (start_read) begin
                        state <= BUSY;
                        status <= 1; // Busy
                    end
                end
                BUSY: begin
                    // Simulate reading from memory (in reality you would interface with memory)
                    data_out <= address + 32'hDEADBEEF; // Example data retrieval
                    state <= DONE;
                end
                DONE: begin
                    status <= 2; // Done
                    state <= IDLE; // Go back to idle
                end
            endcase
        end
    end
endmodule