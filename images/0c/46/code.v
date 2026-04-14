module dma_controller(
    input clk,
    input rst,
    input start,
    input [7:0] data_in,         // Data input
    input [7:0] src_address,     // Source address
    input [7:0] dest_address,    // Destination address
    input [3:0] num_words,       // Number of words to transfer
    output reg [7:0] data_out,    // Data output
    output reg done               // Transfer done signal
);

    reg [3:0] count;              // Counter for words transferred
    reg transferring;             // Transfer state

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            count <= 0;
            done <= 0;
            transferring <= 0;
        end else if (start && !transferring) begin
            count <= num_words;
            transferring <= 1;
            done <= 0;
        end else if (transferring) begin
            if (count > 0) begin
                data_out <= data_in; // Simulate data transfer
                count <= count - 1;
            end else begin
                transferring <= 0;
                done <= 1; // Transfer complete
            end
        end
    end
endmodule