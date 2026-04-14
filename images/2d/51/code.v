module dma_controller (
    input wire clk,
    input wire rst,
    input wire start,
    input wire [7:0] data_in,
    input wire [15:0] addr,
    output reg [7:0] data_out,
    output reg transfer_done
);
    
    reg [1:0] state;
    localparam IDLE = 2'b00, TRANSFER = 2'b01, DONE = 2'b10;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
            data_out <= 8'b0;
            transfer_done <= 1'b0;
        end else begin
            case (state)
                IDLE: begin
                    if (start) begin
                        state <= TRANSFER;
                        transfer_done <= 1'b0;
                    end
                end
                
                TRANSFER: begin
                    data_out <= data_in; // Simulate data transfer
                    state <= DONE;
                end
                
                DONE: begin
                    transfer_done <= 1'b1; // Indicate transfer is done
                    state <= IDLE; // Go back to IDLE
                end
                
                default: state <= IDLE;
            endcase
        end
    end
endmodule