module DMA_Controller (
    input wire clk,
    input wire rst,
    input wire start,
    input wire [7:0] mem_address,
    input wire [7:0] peripheral_data_in,
    output reg [7:0] peripheral_data_out,
    output reg mem_read,
    output reg mem_write,
    output reg busy,
    output reg done
);
    reg [1:0] state;
    localparam IDLE = 2'b00, READ = 2'b01, WRITE = 2'b10, DONE = 2'b11;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
            busy <= 0;
            done <= 0;
            mem_read <= 0;
            mem_write <= 0;
            peripheral_data_out <= 0;
        end else begin
            case (state)
                IDLE: begin
                    done <= 0;
                    if (start) begin
                        busy <= 1;
                        mem_read <= 1; // Start by reading from memory
                        state <= READ;
                    end
                end
                
                READ: begin
                    // Simulate a read from memory
                    peripheral_data_out <= peripheral_data_in; // Simulate read data
                    mem_read <= 0;
                    mem_write <= 1; // Prepare to write to peripheral
                    state <= WRITE;
                end
                
                WRITE: begin
                    // Simulate a write to peripheral
                    mem_write <= 0;
                    busy <= 0; // Transfer is now complete
                    done <= 1; // Indicate done
                    state <= DONE;
                end
                
                DONE: begin
                    if (!start) begin
                        state <= IDLE; // Go back to idle when not starting
                        done <= 0;
                    end
                end
                
                default: state <= IDLE; // Safety case
            endcase
        end
    end
endmodule