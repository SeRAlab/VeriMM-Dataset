module dma_controller (
    input wire clk,
    input wire rst_n,
    input wire start,
    input wire [7:0] src_addr,
    input wire [7:0] dest_addr,
    input wire [7:0] byte_cnt,
    output reg busy,
    output reg [7:0] data_out,
    output reg done
);

    reg [7:0] src_reg;
    reg [7:0] dest_reg;
    reg [7:0] count;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            busy <= 0;
            done <= 0;
            count <= 0;
        end else if (start && !busy) begin
            src_reg <= src_addr;
            dest_reg <= dest_addr;
            count <= byte_cnt;
            busy <= 1;
            done <= 0;
        end else if (busy) begin
            if (count > 0) begin
                // Simulate data transfer
                data_out <= src_reg; // Read from source address
                dest_reg <= data_out; // Write to destination address
                count <= count - 1;
            end else begin
                busy <= 0;
                done <= 1;
            end
        end
    end

endmodule