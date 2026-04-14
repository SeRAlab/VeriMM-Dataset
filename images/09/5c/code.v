module dma_controller (
    input clk,
    input reset,
    input start,
    input [7:0] src_addr,
    input [7:0] dest_addr,
    input [7:0] data_in,
    input [3:0] transfer_count,
    output reg busy,
    output reg completed,
    output reg [7:0] data_out
);
    reg [3:0] count;
    reg [7:0] src_reg;
    reg [7:0] dest_reg;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            busy <= 0;
            completed <= 0;
            count <= 0;
            data_out <= 0;
        end else if (start && !busy) begin
            busy <= 1;
            completed <= 0;
            count <= transfer_count;
            src_reg <= src_addr;
            dest_reg <= dest_addr;
        end else if (busy) begin
            if (count > 0) begin
                data_out <= data_in; // Simulate reading from source memory
                count <= count - 1;
                dest_reg <= dest_reg + 1; // Simulate writing to destination memory
            end else begin
                busy <= 0;
                completed <= 1;
            end
        end
    end
endmodule