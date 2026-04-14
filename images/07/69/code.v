module dma_controller (
    input wire clk,
    input wire rst_n,
    input wire start,
    input wire [7:0] src_addr,
    input wire [7:0] dest_addr,
    input wire [3:0] transfer_size,
    output reg done
);
    reg [3:0] count;
    reg transferring;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            count <= 0;
            done <= 0;
            transferring <= 0;
        end else if (start && !transferring) begin
            count <= 0;
            transferring <= 1;
            done <= 0;
        end else if (transferring) begin
            if (count < transfer_size) begin
                // Simulate data transfer by incrementing the count
                count <= count + 1;
            end else begin
                transferring <= 0;
                done <= 1; // Transfer is complete
            end
        end
    end
endmodule