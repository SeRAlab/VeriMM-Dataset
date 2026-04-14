module dma_controller (
    input clk,
    input rst,
    input start,
    input [7:0] src_addr,
    input [7:0] dest_addr,
    input [7:0] num_bytes,
    output reg busy,
    output reg done
);
    reg [7:0] current_byte;
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            busy <= 0;
            done <= 0;
            current_byte <= 0;
        end else if (start && !busy) begin
            busy <= 1;
            current_byte <= 0;
            done <= 0;
        end else if (busy) begin
            if (current_byte < num_bytes) begin
                current_byte <= current_byte + 1;
            end else begin
                busy <= 0;
                done <= 1;
            end
        end
    end
endmodule