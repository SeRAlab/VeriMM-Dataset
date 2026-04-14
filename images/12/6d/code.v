module dma_controller (
    input wire clk,
    input wire rst_n,
    input wire start,
    input wire [7:0] src_addr,
    input wire [7:0] dest_addr,
    input wire [7:0] data_in,
    output reg ready,
    output reg [7:0] data_out
);

    reg [1:0] state;
    parameter IDLE = 2'b00, READ = 2'b01, WRITE = 2'b10;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
            ready <= 0;
            data_out <= 8'b0;
        end else begin
            case (state)
                IDLE: begin
                    if (start) begin
                        state <= READ;
                        ready <= 0;
                    end
                end
                READ: begin
                    data_out <= data_in;  // Simulate reading data from memory
                    state <= WRITE;
                end
                WRITE: begin
                    // Simulate writing data to memory
                    ready <= 1; // Signal that the transfer is done
                    state <= IDLE;
                end
            endcase
        end
    end
endmodule