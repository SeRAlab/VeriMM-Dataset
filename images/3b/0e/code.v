module dma_controller (
    input wire clk,
    input wire reset,
    input wire start,
    input wire [7:0] source_addr,
    input wire [7:0] dest_addr,
    input wire [7:0] data_in,
    output reg [7:0] data_out,
    output reg transfer_complete
);
    reg [2:0] state;
    parameter IDLE = 3'b000, READ = 3'b001, WRITE = 3'b010, COMPLETE = 3'b011;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            transfer_complete <= 0;
        end else begin
            case (state)
                IDLE: begin
                    if (start) begin
                        state <= READ;
                        transfer_complete <= 0;
                    end
                end
                READ: begin
                    data_out <= data_in; // Simulate reading from memory
                    state <= WRITE;
                end
                WRITE: begin
                    // Simulate writing to memory
                    state <= COMPLETE;
                end
                COMPLETE: begin
                    transfer_complete <= 1;
                    state <= IDLE; // Return to idle state
                end
            endcase
        end
    end
endmodule