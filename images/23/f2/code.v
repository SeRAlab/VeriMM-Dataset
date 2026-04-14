module dma_controller(
    input wire start,
    input wire clk,
    input wire reset,
    input wire [7:0] src_addr,
    input wire [7:0] dest_addr,
    input wire [7:0] data_in,
    output reg [7:0] data_out
);
    reg [1:0] state;
    
    localparam IDLE = 2'b00,
               TRANSFER = 2'b01,
               DONE = 2'b10;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            data_out <= 8'b0;
        end else begin
            case (state)
                IDLE: begin
                    if (start) begin
                        state <= TRANSFER;
                        data_out <= data_in; // Transfer data
                    end
                end
                TRANSFER: begin
                    state <= DONE; // Move to done state after transfer
                end
                DONE: begin
                    state <= IDLE; // Return to idle state
                end
            endcase
        end
    end
endmodule