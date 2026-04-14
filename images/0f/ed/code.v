module dma_controller (
    input wire clk,
    input wire rst,
    input wire start_ch1,
    input wire start_ch2,
    input wire stop_ch1,
    input wire stop_ch2,
    output reg busy_ch1,
    output reg busy_ch2
);
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            busy_ch1 <= 0;
            busy_ch2 <= 0;
        end else begin
            if (start_ch1 && !busy_ch1) begin
                busy_ch1 <= 1;
            end else if (stop_ch1) begin
                busy_ch1 <= 0;
            end
            
            if (start_ch2 && !busy_ch2) begin
                busy_ch2 <= 1;
            end else if (stop_ch2) begin
                busy_ch2 <= 0;
            end
        end
    end
endmodule