module dma_controller (
    input clk,
    input rst,
    input req,
    output reg ack,
    input [7:0] data_in,
    output reg [7:0] data_out,
    output reg [15:0] addr,
    input [15:0] transfer_count
);
    reg [15:0] counter;
    reg [3:0] state;

    parameter IDLE = 0, REQUEST = 1, TRANSFER = 2, DONE = 3;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            ack <= 0;
            state <= IDLE;
            counter <= 0;
        end else begin
            case (state)
                IDLE: begin
                    if (req) begin
                        ack <= 1;
                        state <= REQUEST;
                    end
                end
                REQUEST: begin
                    if (ack) begin
                        addr <= counter; // Assuming addresses are sequential
                        data_out <= data_in; // Transfer data to output
                        state <= TRANSFER;
                    end
                end
                TRANSFER: begin
                    if (counter < transfer_count) begin
                        counter <= counter + 1;
                        addr <= counter; // Increment address
                    end else begin
                        state <= DONE;
                    end
                end
                DONE: begin
                    ack <= 0; // End of transfer
                    state <= IDLE; // Go back to IDLE
                end
            endcase
        end
    end
endmodule