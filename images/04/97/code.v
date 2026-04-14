module dma_controller(
    input clk,
    input rst,
    input start,
    input [7:0] src_addr,
    input [7:0] dest_addr,
    input [15:0] data_in,
    output reg transfer_complete,
    output reg [15:0] data_out
);
    reg [7:0] state;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= 0;
            transfer_complete <= 0;
            data_out <= 0;
        end else begin
            case (state)
                0: if (start) begin
                    state <= 1;
                end
                1: begin
                    data_out <= data_in; // Transfer data
                    transfer_complete <= 1; // Set transfer complete
                    state <= 2; // Move to next state
                end
                2: begin
                    transfer_complete <= 0; // Reset the complete signal
                    state <= 0; // Go back to initial state
                end
            endcase
        end
    end
endmodule