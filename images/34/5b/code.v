module dma_controller (
    input wire clk,
    input wire start,
    input wire [7:0] src_addr,
    input wire [7:0] dest_addr,
    input wire [15:0] data_in,
    output reg [15:0] data_out,
    output reg done
);
    reg [7:0] current_src;
    reg [7:0] current_dest;
    reg [2:0] state;

    localparam IDLE = 3'b000,
               TRANSFER = 3'b001,
               DONE = 3'b010;

    always @(posedge clk) begin
        case (state)
            IDLE: begin
                if (start) begin
                    current_src <= src_addr;
                    current_dest <= dest_addr;
                    data_out <= data_in;
                    state <= TRANSFER;
                    done <= 0;
                end
            end
            TRANSFER: begin
                // Simulate data transfer
                // In a real scenario, you would interface with memory here
                data_out <= data_in;  // Output the data being transferred
                state <= DONE;
            end
            DONE: begin
                done <= 1;
                state <= IDLE;
            end
        endcase
    end
endmodule