module dma_controller(
    input clk,
    input rst,
    input start,
    input [15:0] src_addr,
    input [15:0] dest_addr,
    input [7:0] transfer_size,
    output reg done
);
    reg [7:0] counter;
    reg transferring;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            counter <= 8'b0;
            done <= 0;
            transferring <= 0;
        end else if (start && !transferring) begin
            transferring <= 1;
            counter <= transfer_size;
            done <= 0;
        end else if (transferring) begin
            if (counter > 0) begin
                counter <= counter - 1;
            end else begin
                transferring <= 0;
                done <= 1;
            end
        end
    end
endmodule