module dma_controller(
    input clk,
    input reset,
    input channel0_enable,
    input channel1_enable,
    input [7:0] channel0_address,
    input [7:0] channel1_address,
    output reg channel0_done,
    output reg channel1_done
);
    reg [7:0] addr0;
    reg [7:0] addr1;
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            addr0 <= 8'b0;
            addr1 <= 8'b0;
            channel0_done <= 1'b0;
            channel1_done <= 1'b0;
        end else begin
            if (channel0_enable) begin
                addr0 <= channel0_address;
                channel0_done <= 1'b1; // Simulate transfer complete
            end else begin
                channel0_done <= 1'b0;
            end
            
            if (channel1_enable) begin
                addr1 <= channel1_address;
                channel1_done <= 1'b1; // Simulate transfer complete
            end else begin
                channel1_done <= 1'b0;
            end
        end
    end
endmodule