module dma_controller (
    input wire clk,
    input wire rst,
    input wire start,
    input wire [7:0] src_addr,
    input wire [7:0] dest_addr,
    input wire [7:0] data_in,
    output reg [7:0] data_out,
    output reg done
);

    reg [2:0] state;
    reg [7:0] src_reg;
    reg [7:0] dest_reg;

    localparam IDLE = 3'b000,
               LOAD = 3'b001,
               TRANSFER = 3'b010,
               COMPLETE = 3'b011;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
            done <= 0;
            data_out <= 8'b0;
        end else begin
            case (state)
                IDLE: begin
                    if (start) begin
                        src_reg <= src_addr;
                        dest_reg <= dest_addr;
                        state <= LOAD;
                    end
                end
                LOAD: begin
                    // Simulate reading from memory (for simplification)
                    data_out <= data_in; // Read from src_addr
                    state <= TRANSFER;
                end
                TRANSFER: begin
                    // Simulate writing to memory (for simplification)
                    // Here we just pass the data_out as "written"
                    state <= COMPLETE;
                end
                COMPLETE: begin
                    done <= 1;
                    state <= IDLE; // Go back to idle after done
                end
            endcase
        end
    end
endmodule