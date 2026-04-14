module dma_controller (
    input wire clk,
    input wire reset,
    input wire start,
    input wire [2:0] channel_select,
    input wire [15:0] src_addr,
    input wire [15:0] dest_addr,
    output reg transfer_complete,
    output reg [15:0] data
);

reg [15:0] memory [0:255]; // Sample memory array
reg [3:0] state; // State variable
reg [15:0] temp_data;

localparam IDLE = 4'b0000,
           READ = 4'b0001,
           WRITE = 4'b0010,
           DONE = 4'b0011;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= IDLE;
        transfer_complete <= 0;
        data <= 0;
    end else begin
        case (state)
            IDLE: begin
                if (start) begin
                    state <= READ;
                    transfer_complete <= 0;
                end
            end
            READ: begin
                temp_data <= memory[src_addr + channel_select]; // Read data
                state <= WRITE;
            end
            WRITE: begin
                memory[dest_addr + channel_select] <= temp_data; // Write data
                transfer_complete <= 1; // Mark transfer as complete
                state <= DONE;
            end
            DONE: begin
                state <= IDLE; // Return to idle state
            end
        endcase
    end
end

endmodule