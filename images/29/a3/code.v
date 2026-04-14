module dma_controller(
    input wire clk,
    input wire reset,
    input wire start,
    input wire [7:0] src_addr,
    input wire [7:0] dest_addr,
    output reg transfer_complete,
    output reg [7:0] data_out
);
    reg [7:0] src;
    reg [7:0] dest;
    reg [2:0] state;

    localparam IDLE = 3'b000,
               TRANSFER = 3'b001,
               COMPLETE = 3'b010;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            transfer_complete <= 0;
            data_out <= 8'b0;
        end else begin
            case (state)
                IDLE: begin
                    if (start) begin
                        src <= src_addr;
                        dest <= dest_addr;
                        state <= TRANSFER;
                        transfer_complete <= 0;
                    end
                end
                TRANSFER: begin
                    // Simulate data transfer by simply moving data
                    data_out <= src; // Assume the data is present at src
                    src <= src + 1;  // Increment source address
                    dest <= dest + 1; // Increment destination address
                    if (src == src_addr + 8) begin // Assume we transfer 8 bytes
                        state <= COMPLETE;
                    end
                end
                COMPLETE: begin
                    transfer_complete <= 1; // Indicate transfer complete
                    state <= IDLE; // Go back to idle state
                end
            endcase
        end
    end
endmodule