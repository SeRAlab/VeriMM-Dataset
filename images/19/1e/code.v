module dma_controller (
    input clk,
    input rst_n,
    input start,
    input [7:0] num_bytes, // number of bytes to transfer
    output reg done,
    output reg [7:0] data_out // data being transferred
);
    reg [3:0] byte_count; // count of bytes transferred
    reg transferring; // indicates if transfer is in progress

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            done <= 0;
            byte_count <= 0;
            transferring <= 0;
            data_out <= 0;
        end else begin
            if (start && !transferring) begin
                transferring <= 1;
                byte_count <= 0;
                data_out <= 8'hAA; // example data to transfer
                done <= 0;
            end
            if (transferring) begin
                if (byte_count < num_bytes) begin
                    // Simulate data transfer
                    data_out <= data_out + 1; // increment data for next byte
                    byte_count <= byte_count + 1;
                end else begin
                    transferring <= 0;
                    done <= 1; // transfer is complete
                end
            end
        end
    end
endmodule