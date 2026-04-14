module dma_controller (
    input wire clk,
    input wire reset,
    input wire start_channel1,
    input wire start_channel2,
    input wire [7:0] src_addr1,
    input wire [7:0] dest_addr1,
    input wire [7:0] length1,
    input wire [7:0] src_addr2,
    input wire [7:0] dest_addr2,
    input wire [7:0] length2,
    output reg busy_channel1,
    output reg busy_channel2,
    output reg done_channel1,
    output reg done_channel2
);
    reg [7:0] current_length1;
    reg [7:0] current_length2;
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            busy_channel1 <= 0;
            busy_channel2 <= 0;
            done_channel1 <= 0;
            done_channel2 <= 0;
            current_length1 <= 0;
            current_length2 <= 0;
        end else begin
            if (start_channel1 && !busy_channel1) begin
                busy_channel1 <= 1;
                current_length1 <= length1;
                done_channel1 <= 0;
            end
            
            if (busy_channel1) begin
                if (current_length1 > 0) begin
                    current_length1 <= current_length1 - 1;
                end else begin
                    busy_channel1 <= 0;
                    done_channel1 <= 1;
                end
            end
            
            if (start_channel2 && !busy_channel2) begin
                busy_channel2 <= 1;
                current_length2 <= length2;
                done_channel2 <= 0;
            end
            
            if (busy_channel2) begin
                if (current_length2 > 0) begin
                    current_length2 <= current_length2 - 1;
                end else begin
                    busy_channel2 <= 0;
                    done_channel2 <= 1;
                end
            end
        end
    end
endmodule