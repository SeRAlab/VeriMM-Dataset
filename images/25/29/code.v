module dma_controller (
    input wire clk,
    input wire start,
    input wire [7:0] src_addr,
    input wire [7:0] dst_addr,
    input wire [7:0] data_in,
    input wire ack,
    output reg [7:0] data_out,
    output reg done
);
    reg [7:0] src_addr_reg;
    reg [7:0] dst_addr_reg;
    reg [2:0] byte_count; // counts bytes transferred

    always @(posedge clk) begin
        if (start) begin
            src_addr_reg <= src_addr;
            dst_addr_reg <= dst_addr;
            byte_count <= 3'b0;
            done <= 1'b0;
        end else if (byte_count < 3'd8) begin
            if (ack) begin // wait for ack signal
                data_out <= data_in; // transfer data
                src_addr_reg <= src_addr_reg + 1; // increment src
                dst_addr_reg <= dst_addr_reg + 1; // increment dst
                byte_count <= byte_count + 1; // increment byte count
            end
        end else begin
            done <= 1'b1; // signal done after 8 bytes
        end
    end
endmodule