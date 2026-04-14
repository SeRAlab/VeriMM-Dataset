module dma_controller(
    input clk,
    input rst,
    input start,
    input [7:0] src_addr,
    input [7:0] dst_addr,
    input [31:0] data_in,
    output reg [31:0] data_out,
    output reg done
);
    reg [7:0] current_src;
    reg [7:0] current_dst;
    reg transferring;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            current_src <= 8'd0;
            current_dst <= 8'd0;
            data_out <= 32'd0;
            done <= 1'b0;
            transferring <= 1'b0;
        end else if (start && !transferring) begin
            current_src <= src_addr;
            current_dst <= dst_addr;
            transferring <= 1'b1;
            done <= 1'b0;
        end else if (transferring) begin
            data_out <= data_in; // Simulating the transfer of data
            transferring <= 1'b0; // End transfer after one word
            done <= 1'b1; // Indicate that transfer is complete
        end
    end
endmodule